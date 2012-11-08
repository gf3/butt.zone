- (void)webView:(WebView *)webView exceptionWasRaised:(WebScriptCallFrame *)frame hasHandler:(BOOL)hasHandler sourceId:(WebSourceId)sid line:(int)lineno forWebFrame:(WebFrame *)webFrame
{
  JSContextRef context      = JSGlobalContextCreate(NULL);
  JSValueRef  *ex           = NULL;
  JSStringRef  propertyName = JSStringCreateWithUTF8CString("constructor");
  JSValueRef   property     = JSObjectGetProperty(context, [[frame exception] JSObject], propertyName, ex);

  propertyName = JSStringCreateWithUTF8CString("name");
  property     = JSObjectGetProperty(context, property, propertyName, ex);
}

