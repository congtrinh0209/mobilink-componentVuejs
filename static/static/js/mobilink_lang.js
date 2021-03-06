var vi_VN = {
  'email': 'Email',
  'telNo': 'Số điện thoại liên lạc',
  'startDate': 'Ngày bắt đầu',
  'employeeNo': 'Mã nhân viên',
  'processNo': 'Số hiệu quy trình',
  'codeNo': 'Số văn bản',
  'templateNo': 'Số hiệu mẫu',
  'projectNo': 'Số hiệu dự án',
  'archiveNo': 'Số hồ sơ',
  'roleId': 'Đơn vị/ nhóm',
  'toUserId': 'Cá nhân',
  'managerId': 'Mã người phụ trách/ thực hiện',
  'managerName': 'Tên người phụ trách/ thực hiện',
  'hostingId': 'Mã đơn vị chủ trì',
  'groupCode': 'Mã code nhóm',
  'jobCode': 'Mã chức vụ',
  'issuerCode': 'Mã cơ quan ban hành',
  'govAgencyCode': 'Mã phòng ban',
  'categoryName': 'Tên lĩnh vực',
  'subject' : 'Tên hoạt động',
  'collectionCode' : 'Mã danh mục',
  'itemCode': 'Mã code dữ liệu',
  'groupCode' : 'Mã code nhóm',
  'className' : 'Lớp đối tượng gốc',
  'classPK' : 'PK của đối tượng gốc',
  'textMessage': 'Nội dung thông báo',
  'fullName' : 'Tên cá nhân, đơn vị, nhóm',
  'name' : 'Tên vùng làm việc',
  'scope': 'Phạm vi áp dụng',
  'tag': 'Chuỗi nhãn',
  'processName': 'Tên quy trình',
  'processNo': 'Số hiệu quy trình',
  'fileEntryId': 'fileEntryId',
  'doItem': 'Tên công việc thực hiện',
  'activityId': 'Mã hoạt động',
  'projectName': 'Tên dự án/ hợp đồng',
  'projectNo': 'Số hiệu dự án/hợp đồng',

  'duplicate': 'đã tồn tại',
  'required': 'là bắt buộc',

};
var en_US = {
  'email': 'Email',
  'telNo': 'Telephone number',
  'startDate': 'Start date',
  'employeeNo': 'Employee number',
  'processNo': 'Process number',
  'codeNo': 'Document number',
  'templateNo': 'Template number',
  'projectNo': 'Project number',
  'archiveNo': 'Archive number',
  'roleId': 'Working unit',
  'toUserId': 'User',
  'managerId': 'Manager code',
  'managerName': 'Manager name',
  'hostingId': 'Hosting code',
  'groupCode': 'Group code',
  'jobCode': 'Jobpos code',
  'issuerCode': 'Issuer code',
  'govAgencyCode': 'Government agency code',
  'categoryName': 'Category name',
  'subject' : 'Subject',
  'collectionCode' : 'Collection Code',
  'itemCode' : 'Data code',
  'groupCode' : 'Group code',
  'className' : 'Class name',
  'classPK' : 'Class PK',
  'textMessage' : 'textMessage',
  'fullName' : 'Full name',
  'name' : 'Workspace name',
  'scope': 'Scope',
  'Tag' : 'Tag',
  'processName': 'Process name',
  'processNo': 'Process number',
  'fileEntryId': 'fileEntryId',
  'doItem': 'doItem name',
  'activityId': 'Activity code',
  'projectName' : 'Project name',
  'projectNo': 'Project number',

  'duplicate': 'is duplicate',
  'required': 'is required'

};

// Get message notification
var lang_locale = themeDisplay.getLanguageId();
// var lang_locale = 'vi_VN';

var notify = function(res){
  var mess = res.message?res.message:'';
  var type_err = res.type?res.type:'';
  var type_errText;
  if(type_err == 'maxlength'&&mess.search(":")>0){
    type_errText = mess?mess.match(':\"(.*)\"}')[1]:'';
  }
  var target  = (mess&&mess.search(":")>0)?mess.match('\"(.*)\":')[1]:'';

  class multil_lang {
    constructor(lang) {
      if (lang == 'vi_VN') {
        this.language = vi_VN;
      } else {
        this.language = en_US;
      }
      this.translate = function(key) {
        return this.language[key]?this.language[key]:'';
      }
    }
  }
  var language = new multil_lang(lang_locale);
  if(type_err == 'maxlength'){
    return (mess&&type_err)?('Độ dài '+language.translate(target)+' không quá '+type_errText+' ký tự'):'';
  } else {
    return (mess&&type_err)?(language.translate(target)+' '+language.translate(type_err)):'';
  }
  
}

// Compile html multi language
var compile_language = function () {	
	$("[m-lang]").each (function (index) {
    var attr_val = $(this).attr ('m-lang');
    var str = mobilink_lang(lang_locale).translate(attr_val);
	  $(this).html(str);
	});
}
// compile_language();
// 
var mobilink_lang = function(lang){
  class multil_lang {
    constructor(lang) {
      if (lang == 'vi_VN') {
        this.language = vi_VN;
      } else {
        this.language = en_US;
      }
      this.translate = function(key) {
        return this.language[key];
      }
    }
  }
  var language;
  return language = new multil_lang(lang_locale);
  // return language.translate(str);
}
var m_lang = mobilink_lang(lang_locale).language;
mobilink_lang(lang_locale);