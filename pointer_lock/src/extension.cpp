
#include <dmsdk/sdk.h>
#if defined(DM_PLATFORM_HTML5)
#include <emscripten.h>
#endif

#define GLFW_MOUSE_CURSOR 0x00030001
extern "C"
{
    void glfwDisable(int token);
    void glfwEnable(int token);
}

static int Glfw_MouseLock(lua_State* L)
{
    glfwDisable(GLFW_MOUSE_CURSOR);
    return 0;
}

static int Glfw_MouseUnlock(lua_State* L)
{
    glfwEnable(GLFW_MOUSE_CURSOR);
    return 0;
}

#if defined(DM_PLATFORM_HTML5)
typedef void (*DefPointerLock_OnPointerLockChange)(const bool locked);
typedef void (*DefPointerLock_OnCanvasClick)();
extern "C" void DefPointerLock_Init(DefPointerLock_OnPointerLockChange on_change, DefPointerLock_OnCanvasClick on_click);
extern "C" void DefPointerLock_Final();
extern "C" void DefPointerLock_RequestPointerLock();
extern "C" void DefPointerLock_ExitPointerLock();

static dmScript::LuaCallbackInfo *m_OnClick;
static bool m_PointerLocked;

static int Html5_RequestPointerLock(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 0);
    DefPointerLock_RequestPointerLock();
    return 0;
}

static int Html5_ExitPointerLock(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 0);
    DefPointerLock_ExitPointerLock();
    return 0;
}

static int Html5_PointerLocked(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 1);
    lua_pushboolean(L, m_PointerLocked);
    return 1;
}

static void OnPointerLockChange(const bool locked)
{
    m_PointerLocked = locked;
}

static int Html5_OnClick(lua_State* L)
{
    DM_LUA_STACK_CHECK(L, 0);
    if (lua_isfunction(L, 1)) {
        m_OnClick = dmScript::CreateCallback(L, 1);
    } else {
        dmScript::DestroyCallback(m_OnClick);
        m_OnClick = 0x0;
    }
    return 0;
}

static void OnCanvasClick()
{
    if (!dmScript::IsCallbackValid(m_OnClick)) {
        return;
    }

    lua_State *L = dmScript::GetCallbackLuaContext(m_OnClick);

    if (!dmScript::SetupCallback(m_OnClick)) {
        dmScript::DestroyCallback(m_OnClick);
        m_OnClick = 0x0;
        return;
    }

    dmScript::PCall(L, 1, 0);

    dmScript::TeardownCallback(m_OnClick);
}

#endif

// Functions exposed to Lua
static const luaL_reg Module_methods[] = {
    { "glfw_mouse_lock", Glfw_MouseLock },
    { "glfw_mouse_unlock", Glfw_MouseUnlock },
#if defined(DM_PLATFORM_HTML5)
    { "html5_request_pointer_lock", Html5_RequestPointerLock },
    { "html5_exit_pointer_lock", Html5_ExitPointerLock },
    { "html5_pointer_locked", Html5_PointerLocked },
    { "html5_on_click", Html5_OnClick },
#endif
    /* Sentinel: */
    { NULL, NULL }
};

static void LuaInit(lua_State* L)
{
    int top = lua_gettop(L);

    // Register lua names
    luaL_register(L, "pointer_lock_ext", Module_methods);

    lua_pop(L, 1);
    assert(top == lua_gettop(L));
}

static dmExtension::Result InitializeExt(dmExtension::Params* params)
{
    LuaInit(params->m_L);

#if defined(DM_PLATFORM_HTML5)
    DefPointerLock_Init(OnPointerLockChange, OnCanvasClick);
#endif

    return dmExtension::RESULT_OK;
}

static dmExtension::Result FinalizeExt(dmExtension::Params* params)
{
#if defined(DM_PLATFORM_HTML5)
    DefPointerLock_Final();
#endif

    return dmExtension::RESULT_OK;
}

DM_DECLARE_EXTENSION(pointer_lock, "pointer_lock", 0, 0, InitializeExt, 0, 0, FinalizeExt)
