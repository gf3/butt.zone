Whilst building your fancy client-side app analyzer and messing about with the WebKit framework you may or mayn't have noticed that it thoughtfully provides you with some delegate methods for debugging. And while building detailed reporting for your application you surely felt it necessary to include *tertiary* information about exceptions—such as its type.

Typically in JavaScript we'd introspect this from the exception's constructor. No problem, right? It's as easy as something like this:

```objective-c
- (void)webView:(WebView *)webView exceptionWasRaised:(WebScriptCallFrame *)frame hasHandler:(BOOL)hasHandler sourceId:(WebSourceId)sid line:(int)lineno forWebFrame:(WebFrame *)webFrame
{
  JSContextRef context      = JSGlobalContextCreate(NULL);
  JSValueRef  *ex           = NULL;
  JSStringRef  propertyName = JSStringCreateWithUTF8CString("constructor");
  JSValueRef   property     = JSObjectGetProperty(context, [[frame exception] JSObject], propertyName, ex);

  propertyName = JSStringCreateWithUTF8CString("name");
  property     = JSObjectGetProperty(context, property, propertyName, ex);
}
```

**WRONG!** You won't even be able to get `constructor` let alone `name`. No matter how you try and coerce it out of the exception's `JSObject` you'll find yourself with undefined values and empty dreams.

Fortunately my friend, [Malcolm](//twitter.com/mjarvis), had the deliciously evil idea of injecting JavaScript into the page, reflecting, and then passing the value back to Objective-C. Thankfully WebKit provides us with a few nifty methods to connect our Objective-C with JavaScript et vice versa. It sounded just crazy enough to try:

```objective-c
- (void)webView:(WebView *)webView exceptionWasRaised:(WebScriptCallFrame *)frame hasHandler:(BOOL)hasHandler sourceId:(WebSourceId)sid line:(int)lineno forWebFrame:(WebFrame *)webFrame
{
  [[webFrame windowObject] setValue:[frame exception] forKey:@"__GC_frame_exception"];
  id objectRef = [[webFrame windowObject] evaluateWebScript:@"__GC_frame_exception.constructor.name"];
  [[webFrame windowObject] setValue:nil forKey:@"__GC_frame_exception"];
}
```

**HOLY SHIT!** It *fucking* worked! What a silly little hackity hack—but it works. This lets us easily introspect the type name of exceptions (e.g. `SyntaxError` vs. `TypeError`).

Why does this work and C version does not? Well after a brief conversation with a WebKit developer it sounds like this might be an actual bug in either WebKit or JavaScriptCore. Fingers crossed that it gets fixed.


### Postscript

You might be thinking hey I can grab the associated prototype object and find the name from there—stop thinking that it doesn't work either.
