component extends="mura.plugin.plugincfc" output="false" {

	variables.config="";
	variables.instance.extensionManager = application.classExtensionManager;
	
	public function init(any config) {
	  variables.config = arguments.config;
	}
	
	public void function install() {
	  application.appInitialized=false;
	  ormReload();
	}
	
	public void function update() {
	  application.appInitialized=false;
	  ormReload();
	}
	
	public void function delete() {
	  ormReload();
	}
	
	

}

