component extends="mura.cfobject" output="false" {

	variables.fw = "";

	public void function init(required any fw) {
		variables.fw = arguments.fw;
	}
}
