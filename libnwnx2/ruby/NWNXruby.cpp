#include "NWNXruby.h"

CNWNXruby::CNWNXruby() {
	confKey = "ruby";
}

CNWNXruby::~CNWNXruby() {
	ruby_finalize();
}

bool CNWNXruby::OnCreate(gline *config, const char *LogDir) {
	char log[128];
	sprintf (log, "%s/nwnx_ruby.txt", LogDir);

	// call the base class function
	if (!CNWNXBase::OnCreate(config,log))
		return false;

	// spelunk nwnx2.ini for a connection section
	if (!Configure())
		return false;

	// Create the interpreter
	ruby_init();
	ruby_init_loadpath();

	rb_load_file(scriptname);
	return true;
}

//VALUE wrap_eval(VALUE arg) {
//}

void CNWNXruby::Reload() {
	ruby_finalize();
	ruby_init();
	ruby_init_loadpath();
	VALUE we = rb_define_class("CNWNXruby", rb_cObject);
	rb_define_method(we, "nwnx", VALUEFUNC(CNWNXruby::FromRuby), 1);
	rb_load_file(scriptname);
}

VALUE CNWNXruby::Ruby(char *Request) {
	VALUE result = rb_eval_string(Request);
	//rb_protect(eval_wrap, 0, &error);
	//if (error)
	//	throw;
	return result;
}



VALUE CNWNXruby::FromRuby(VALUE self, VALUE data) {
	return data;
}

char *CNWNXruby::OnRequest(char *gameObject, char *Request, char* Parameters) {
	int len;
	char cmd[32], *bang;

	Log(2,"Request: %s\n",Request);
	Log(3,"Params : %s\n",Parameters);

	if((bang = strchr(Request,'!'))==NULL) {
		sprintf(ruby_buf, "no command found.");
		ParamLog(0,ruby_buf, Parameters);
		return NULL;
	}
	len = bang - Request;
	strncpy(cmd, Request, len);
	cmd[len] = 0;

	if(strcmp("ruby", cmd)==0) {
		VALUE ret = Ruby(Parameters);
		// return the string to nwn
		sprintf(ruby_buf, "%s", RSTRING(ret));
	} else if (strcmp("reload", cmd) == 0) {
		Reload();
	} else {
		sprintf(ruby_buf, "[%s] bad command", cmd);
		ParamLog(0,ruby_buf,Parameters);
	}

	return NULL;
}

bool CNWNXruby::Configure() {

	if(nwnxConfig->exists(confKey)) {
		// run/eval scriptname
		scriptname = (char*)((*nwnxConfig)[confKey]["script"].c_str());
	}

	return true;
}
