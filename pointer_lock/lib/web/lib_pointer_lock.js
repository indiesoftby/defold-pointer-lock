var LibraryDefPointerLock = {
    $DefPointerLock: {
        _onPointerLockChange: null,
        onPointerLockChange: function () {
            var locked =
                (document.pointerLockElement ||
                    document.mozPointerLockElement ||
                    document.webkitPointerLockElement ||
                    document.msPointerLockElement) == Module.canvas;
            {{{ makeDynCall('vi', 'DefPointerLock._onPointerLockChange') }}}(locked);
        },
        onPointerLockError: function (e) {
            console.log("onPointerLockError", e);
        },
        _onCanvasClick: null,
        onCanvasClick: function (e) {
            {{{ makeDynCall('vi', 'DefPointerLock._onCanvasClick') }}}();
        },
    },

    DefPointerLock_Init: function (onChange, onClick) {
        var self = DefPointerLock;
        self._onPointerLockChange = onChange;
        self._onCanvasClick = onClick;

        if ("onpointerlockchange" in document) {
            document.addEventListener("pointerlockchange", self.onPointerLockChange, false);
            document.addEventListener("pointerlockerror", self.onPointerLockError, false);
        } else if ("onmozpointerlockchange" in document) {
            document.addEventListener("mozpointerlockchange", self.onPointerLockChange, false);
            document.addEventListener("mozpointerlockerror", self.onPointerLockError, false);
        } else if ("onwebkitpointerlockchange" in document) {
            document.addEventListener("webkitpointerlockchange", self.onPointerLockChange, false);
            document.addEventListener("webkitpointerlockerror", self.onPointerLockError, false);
        } else if ("onmspointerlockchange" in document) {
            document.addEventListener("mspointerlockchange", self.onPointerLockChange, false);
            document.addEventListener("mspointerlockerror", self.onPointerLockError, false);
        }

        Module.canvas.addEventListener("click", self.onCanvasClick);
    },

    DefPointerLock_Final: function () {
        var self = DefPointerLock;
        self._onPointerLockChange = null;

        if ("onpointerlockchange" in document) {
            document.removeEventListener("pointerlockchange", self.onPointerLockChange);
            document.removeEventListener("pointerlockerror", self.onPointerLockError);
        } else if ("onmozpointerlockchange" in document) {
            document.removeEventListener("mozpointerlockchange", self.onPointerLockChange);
            document.removeEventListener("mozpointerlockerror", self.onPointerLockError);
        } else if ("onwebkitpointerlockchange" in document) {
            document.removeEventListener("webkitpointerlockchange", self.onPointerLockChange);
            document.removeEventListener("webkitpointerlockerror", self.onPointerLockError);
        } else if ("onmspointerlockchange" in document) {
            document.removeEventListener("mspointerlockchange", self.onPointerLockChange);
            document.removeEventListener("mspointerlockerror", self.onPointerLockError);
        }

        Module.canvas.removeEventListener("click", self.onCanvasClick);
    },

    DefPointerLock_RequestPointerLock: function () {
        (
            Module.canvas.requestPointerLock ||
            Module.canvas.mozRequestPointerLock ||
            Module.canvas.webkitRequestPointerLock ||
            Module.canvas.msRequestPointerLock ||
            function () {}
        ).call(Module.canvas);
    },

    DefPointerLock_ExitPointerLock: function () {
        (
            document.exitPointerLock ||
            document.mozExitPointerLock ||
            document.webkitExitPointerLock ||
            document.msExitPointerLock ||
            function () {}
        ).call(document);
    },
};

autoAddDeps(LibraryDefPointerLock, "$DefPointerLock");
mergeInto(LibraryManager.library, LibraryDefPointerLock);
