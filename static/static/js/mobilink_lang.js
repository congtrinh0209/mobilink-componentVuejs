var vi = {
  'email' : 'Email',
  'telNo': 'Số điện thoại',

  'duplicate': 'đã tồn tại'
}
var en = {
  'email' : 'Email',
  'telNo': 'Telephone',

  'duplicate': 'is duplicate'
}
// var res = {"code":409,"message":"{\"email\":\"duplicate\"}","description":"conflict data!","type":"duplicate"};
// Get message notification
var notify = function(lang,res){
  var mess = res.message;
  var target  = mess.match('\"(.*)\":')[1];
  var type_err  = mess.match(':\"(.*)\"}')[1];
  class multil_lang {
    constructor(lang) {
      if (lang == 'vi') {
        this.language = vi;
      } else {
        this.language = en;
      }
      this.translate = function(key) {
        return this.language[key];
      }
    }
  }
  var language = new multil_lang(lang);
  return language.translate(target)+' '+language.translate(type_err);
}

// Compile html multi language
var compile_language = function (lang) {	
	$("[m-lang]").each (function (index) {
    var attr_val = $(this).attr ('m-lang');
    var str = mobilink_lang(lang).translate(attr_val);
	  $(this).html(str);
	});
}
// compile_language('vi');
// 
var mobilink_lang = function(lang){
  class multil_lang {
    constructor(lang) {
      if (lang == 'vi') {
        this.language = vi;
      } else {
        this.language = en;
      }
      this.translate = function(key) {
        return this.language[key];
      }
    }
  }
  return language = new multil_lang(lang);
  // return language.translate(str);
}
var m_lang = mobilink_lang('vi').language;
mobilink_lang('vi');