(this.nativeLog || function(s) {console.log(s)})('START WEEX HTML5: 0.3.2 Build 20160913');
/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;
/******/
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports) {

	'use strict';
	
	import Weex from './render';
	
	/**
	 * install components and APIs
	 */
	import root from './base/root';
	import div from './base/div';
	import components from './extend/components';
	import api from './extend/api';
	
	Weex.install(root);
	Weex.install(div);
	Weex.install(components);
	Weex.install(api);
	
	export default Weex;

/***/ }
/******/ ]);
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJzb3VyY2VzIjpbIndlYnBhY2s6Ly8vd2VicGFjay9ib290c3RyYXAgMTI5ZWM3NTgyNWIyMzcwODNjMjYiLCJ3ZWJwYWNrOi8vLy4vaHRtbDUvYnJvd3Nlci9pbmRleC5qcyJdLCJuYW1lcyI6WyJXZWV4Iiwicm9vdCIsImRpdiIsImNvbXBvbmVudHMiLCJhcGkiLCJpbnN0YWxsIl0sIm1hcHBpbmdzIjoiOztBQUFBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7O0FBRUE7QUFDQTtBQUNBLHVCQUFlO0FBQ2Y7QUFDQTtBQUNBOztBQUVBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBO0FBQ0E7OztBQUdBO0FBQ0E7O0FBRUE7QUFDQTs7QUFFQTtBQUNBOztBQUVBO0FBQ0E7Ozs7Ozs7QUN0Q0E7O0FBRUEsUUFBT0EsSUFBUCxNQUFpQixVQUFqQjs7QUFFQTs7O0FBR0EsUUFBT0MsSUFBUCxNQUFpQixhQUFqQjtBQUNBLFFBQU9DLEdBQVAsTUFBZ0IsWUFBaEI7QUFDQSxRQUFPQyxVQUFQLE1BQXVCLHFCQUF2QjtBQUNBLFFBQU9DLEdBQVAsTUFBZ0IsY0FBaEI7O0FBRUFKLE1BQUtLLE9BQUwsQ0FBYUosSUFBYjtBQUNBRCxNQUFLSyxPQUFMLENBQWFILEdBQWI7QUFDQUYsTUFBS0ssT0FBTCxDQUFhRixVQUFiO0FBQ0FILE1BQUtLLE9BQUwsQ0FBYUQsR0FBYjs7QUFFQSxnQkFBZUosSUFBZixDIiwiZmlsZSI6ImJyb3dzZXIuanMiLCJzb3VyY2VzQ29udGVudCI6WyIgXHQvLyBUaGUgbW9kdWxlIGNhY2hlXG4gXHR2YXIgaW5zdGFsbGVkTW9kdWxlcyA9IHt9O1xuXG4gXHQvLyBUaGUgcmVxdWlyZSBmdW5jdGlvblxuIFx0ZnVuY3Rpb24gX193ZWJwYWNrX3JlcXVpcmVfXyhtb2R1bGVJZCkge1xuXG4gXHRcdC8vIENoZWNrIGlmIG1vZHVsZSBpcyBpbiBjYWNoZVxuIFx0XHRpZihpbnN0YWxsZWRNb2R1bGVzW21vZHVsZUlkXSlcbiBcdFx0XHRyZXR1cm4gaW5zdGFsbGVkTW9kdWxlc1ttb2R1bGVJZF0uZXhwb3J0cztcblxuIFx0XHQvLyBDcmVhdGUgYSBuZXcgbW9kdWxlIChhbmQgcHV0IGl0IGludG8gdGhlIGNhY2hlKVxuIFx0XHR2YXIgbW9kdWxlID0gaW5zdGFsbGVkTW9kdWxlc1ttb2R1bGVJZF0gPSB7XG4gXHRcdFx0ZXhwb3J0czoge30sXG4gXHRcdFx0aWQ6IG1vZHVsZUlkLFxuIFx0XHRcdGxvYWRlZDogZmFsc2VcbiBcdFx0fTtcblxuIFx0XHQvLyBFeGVjdXRlIHRoZSBtb2R1bGUgZnVuY3Rpb25cbiBcdFx0bW9kdWxlc1ttb2R1bGVJZF0uY2FsbChtb2R1bGUuZXhwb3J0cywgbW9kdWxlLCBtb2R1bGUuZXhwb3J0cywgX193ZWJwYWNrX3JlcXVpcmVfXyk7XG5cbiBcdFx0Ly8gRmxhZyB0aGUgbW9kdWxlIGFzIGxvYWRlZFxuIFx0XHRtb2R1bGUubG9hZGVkID0gdHJ1ZTtcblxuIFx0XHQvLyBSZXR1cm4gdGhlIGV4cG9ydHMgb2YgdGhlIG1vZHVsZVxuIFx0XHRyZXR1cm4gbW9kdWxlLmV4cG9ydHM7XG4gXHR9XG5cblxuIFx0Ly8gZXhwb3NlIHRoZSBtb2R1bGVzIG9iamVjdCAoX193ZWJwYWNrX21vZHVsZXNfXylcbiBcdF9fd2VicGFja19yZXF1aXJlX18ubSA9IG1vZHVsZXM7XG5cbiBcdC8vIGV4cG9zZSB0aGUgbW9kdWxlIGNhY2hlXG4gXHRfX3dlYnBhY2tfcmVxdWlyZV9fLmMgPSBpbnN0YWxsZWRNb2R1bGVzO1xuXG4gXHQvLyBfX3dlYnBhY2tfcHVibGljX3BhdGhfX1xuIFx0X193ZWJwYWNrX3JlcXVpcmVfXy5wID0gXCJcIjtcblxuIFx0Ly8gTG9hZCBlbnRyeSBtb2R1bGUgYW5kIHJldHVybiBleHBvcnRzXG4gXHRyZXR1cm4gX193ZWJwYWNrX3JlcXVpcmVfXygwKTtcblxuXG5cbi8qKiBXRUJQQUNLIEZPT1RFUiAqKlxuICoqIHdlYnBhY2svYm9vdHN0cmFwIDEyOWVjNzU4MjViMjM3MDgzYzI2XG4gKiovIiwiJ3VzZSBzdHJpY3QnXG5cbmltcG9ydCBXZWV4IGZyb20gJy4vcmVuZGVyJ1xuXG4vKipcbiAqIGluc3RhbGwgY29tcG9uZW50cyBhbmQgQVBJc1xuICovXG5pbXBvcnQgcm9vdCBmcm9tICcuL2Jhc2Uvcm9vdCdcbmltcG9ydCBkaXYgZnJvbSAnLi9iYXNlL2RpdidcbmltcG9ydCBjb21wb25lbnRzIGZyb20gJy4vZXh0ZW5kL2NvbXBvbmVudHMnXG5pbXBvcnQgYXBpIGZyb20gJy4vZXh0ZW5kL2FwaSdcblxuV2VleC5pbnN0YWxsKHJvb3QpXG5XZWV4Lmluc3RhbGwoZGl2KVxuV2VleC5pbnN0YWxsKGNvbXBvbmVudHMpXG5XZWV4Lmluc3RhbGwoYXBpKVxuXG5leHBvcnQgZGVmYXVsdCBXZWV4XG5cblxuXG4vKiogV0VCUEFDSyBGT09URVIgKipcbiAqKiAuL2h0bWw1L2Jyb3dzZXIvaW5kZXguanNcbiAqKi8iXSwic291cmNlUm9vdCI6IiJ9