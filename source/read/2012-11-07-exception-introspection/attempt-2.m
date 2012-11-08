- (void)webView:(WebView *)webView exceptionWasRaised:(WebScriptCallFrame *)frame hasHandler:(BOOL)hasHandler sourceId:(WebSourceId)sid line:(int)lineno forWebFrame:(WebFrame *)webFrame
{
  [[webFrame windowObject] setValue:[frame exception] forKey:@"__GC_frame_exception"];
  id objectRef = [[webFrame windowObject] evaluateWebScript:@"__GC_frame_exception.constructor.name"];
  [[webFrame windowObject] setValue:nil forKey:@"__GC_frame_exception"];
}

