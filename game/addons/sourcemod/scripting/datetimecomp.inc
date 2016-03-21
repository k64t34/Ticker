#if defined DEBUG
	#define PLUGIN_DATETIME "Пн, 21.мар.2016 16:06:01"
	#if defined PLUGIN_VERSION
		#undef PLUGIN_VERSION
	#endif
	#define PLUGIN_VERSION "Пн, 21.мар.2016 16:06:01"
#endif
#if !defined PLUGIN_NAME
	#define PLUGIN_NAME "Ticker"
#endif
#if !defined PLUGIN_AUTHOR
	#define PLUGIN_AUTHOR "KOM64T"
#endif
