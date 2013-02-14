<pre class="prettyprint linenums language-js">
-- Request Objects & Values
$.slatwall.getAccount()
$.slatwall.account()
$.slatwall.account('propertyName')
$.slatwall.account('propertyName', 'newValue')
$.slatwall.cart()
$.slatwall.product()
$.slatwall.productList()

-- Custom Request Values
$.slatwall.setValue('customKey', 'customValue')
$.slatwall.getValue('customKey')

-- Session Value API
$.slatwall.getSessionValue('key')
$.slatwall.setSessionValue('key', 'value')

-- Application Value API
$.slatwall.getApplicationValue('key')
$.slatwall.setApplicationValue('key', 'value')

-- Event API
$.slatwall.announceEvent('eventName')
$.slatwall.registerEventHandler('cfc or path to cfc')

-- Model API
$.slatwall.getBean('beanName')
$.slatwall.getService('serviceName')
$.slatwall.getTransient('transientName')

-- Also Available via jQuery
$.slatwall.getSmartList('entityName', data)
$.slatwall.getEntity('entityName', 'entityID')
$.slatwall.saveEntity('entityName', data)
$.slatwall.deleteEntity('entityName', data)
$.slatwall.processEntity('entityName', data, 'processContext')
</pre>