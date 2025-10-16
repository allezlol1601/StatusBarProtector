package com.statusbar.protector;

import android.view.View;
import android.view.Window;
import android.view.WindowManager;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

public class MainHook implements IXposedHookLoadPackage {

    private static final String TAG = "StatusBarProtector";

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable {
        if (lpparam.packageName.equals("android") || 
            lpparam.packageName.equals("com.android.systemui")) {
            return; // Ne pas hooker les packages système
        }

        XposedBridge.log(TAG + ": Hooking " + lpparam.packageName);

        // Hook 1: WindowManager.LayoutParams pour empêcher les flags fullscreen
        hookWindowLayoutParams(lpparam);

        // Hook 2: Window.setFlags pour intercepter les modifications
        hookWindowSetFlags(lpparam);

        // Hook 3: View.setSystemUiVisibility pour empêcher les modes immersifs
        hookSystemUiVisibility(lpparam);

        // Hook 4: WindowInsetsController (Android 11+)
        hookWindowInsetsController(lpparam);
    }

    private void hookWindowLayoutParams(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            XposedHelpers.findAndHookConstructor(
                WindowManager.LayoutParams.class,
                int.class, int.class, int.class, int.class, int.class,
                new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
                        WindowManager.LayoutParams params = (WindowManager.LayoutParams) param.thisObject;
                        removeFullscreenFlags(params);
                    }
                }
            );
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking LayoutParams constructor: " + t.getMessage());
        }
    }

    private void hookWindowSetFlags(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            XposedHelpers.findAndHookMethod(
                Window.class,
                "setFlags",
                int.class, int.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        int flags = (int) param.args[0];
                        int mask = (int) param.args[1];

                        // Retirer les flags fullscreen
                        flags &= ~WindowManager.LayoutParams.FLAG_FULLSCREEN;
                        flags &= ~WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS;
                        
                        param.args[0] = flags;
                        
                        XposedBridge.log(TAG + ": Removed fullscreen flags");
                    }
                }
            );
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking Window.setFlags: " + t.getMessage());
        }
    }

    private void hookSystemUiVisibility(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            XposedHelpers.findAndHookMethod(
                View.class,
                "setSystemUiVisibility",
                int.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        int visibility = (int) param.args[0];

                        // Retirer les flags qui cachent la barre d'état
                        visibility &= ~View.SYSTEM_UI_FLAG_FULLSCREEN;
                        visibility &= ~View.SYSTEM_UI_FLAG_IMMERSIVE;
                        visibility &= ~View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY;
                        visibility &= ~View.SYSTEM_UI_FLAG_HIDE_NAVIGATION;
                        
                        // Forcer l'affichage de la barre d'état
                        visibility |= View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
                        
                        param.args[0] = visibility;
                        
                        XposedBridge.log(TAG + ": Modified system UI visibility");
                    }
                }
            );
        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking setSystemUiVisibility: " + t.getMessage());
        }
    }

    private void hookWindowInsetsController(XC_LoadPackage.LoadPackageParam lpparam) {
        try {
            Class<?> windowInsetsControllerClass = XposedHelpers.findClass(
                "android.view.WindowInsetsController", lpparam.classLoader);

            // Hook hide() pour empêcher de cacher la barre d'état
            XposedHelpers.findAndHookMethod(
                windowInsetsControllerClass,
                "hide",
                int.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        int types = (int) param.args[0];
                        
                        // WindowInsets.Type.statusBars() = 1
                        // Empêcher de cacher la barre d'état
                        if ((types & 1) != 0) {
                            types &= ~1;
                            param.args[0] = types;
                            XposedBridge.log(TAG + ": Prevented hiding status bar via WindowInsetsController");
                        }
                        
                        // Si plus rien à cacher, annuler l'appel
                        if (types == 0) {
                            param.setResult(null);
                        }
                    }
                }
            );

            // Hook setSystemBarsBehavior pour empêcher les modes immersifs
            XposedHelpers.findAndHookMethod(
                windowInsetsControllerClass,
                "setSystemBarsBehavior",
                int.class,
                new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
                        // Forcer le comportement par défaut (pas immersif)
                        param.args[0] = 0; // BEHAVIOR_DEFAULT
                        XposedBridge.log(TAG + ": Forced default system bars behavior");
                    }
                }
            );

        } catch (Throwable t) {
            XposedBridge.log(TAG + ": Error hooking WindowInsetsController: " + t.getMessage());
        }
    }

    private void removeFullscreenFlags(WindowManager.LayoutParams params) {
        params.flags &= ~WindowManager.LayoutParams.FLAG_FULLSCREEN;
        params.flags &= ~WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS;
        
        // S'assurer que la barre d'état n'est pas translucide
        params.flags &= ~WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS;
        
        XposedBridge.log(TAG + ": Cleaned window layout params");
    }
}
