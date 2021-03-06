<!-- TODO Template Xây dựng navigation -->
<input type="hidden">
<div id="menu_template" class="hidden">
  <v-slide-x-transition>
    <div class="layout row wrap" v-if="currentListPage">

      <div class="flex xs12">
        <v-menu transition="slide-x-transition" full-width>
          <v-btn slot="activator" block color="primary" class="btn--menu-add my-0">
            Thêm mới
          </v-btn>
          <v-list>
            <v-list-tile v-for="item in menuSelectItems" :key="item.id" @click="menuSelect(item.id)" :class="item.extClass">
              <v-list-tile-title>
                {{ item.title }}
              </v-list-tile-title>
            </v-list-tile>
          </v-list>
        </v-menu>
      </div>
      <v-expansion-panel expand class="my-0 expMenu" style="box-shadow: none!important;border:0px;width: 100%;">
        <v-expansion-panel-content value="true">
          <div slot="header" class="pl-3 py-2 nav__btn__custom" style="color: rgba(0,0,0,0.87)!important;font-family: 'Roboto',sans-serif!important;"  @click="viewThumuc">
            <v-icon>storage </v-icon>
            Thư mục lưu trữ
          </div>
          
          <v-card style="background-color: #EFEFEF!important;">
            <v-card-text class="px-0 py-0">
              <div class="flex xs12 pl-3" jx-bind="workspace0Filter" class="workspace0Filter"></div>

              <div class="flex xs12 pl-3 hidden_fak_temp" jx-bind="docFileTemplateFilter"></div>
            </v-card-text>
          </v-card>
        </v-expansion-panel-content>
      </v-expansion-panel>
      

      <div class="flex xs12 pl-3 nav__btn__custom">
        <v-btn block flat class="mx-0 my-0 px-0" v-on:click.native="filterDocFileChangeBTN('me')">
          <v-icon>person</v-icon>
          Tài liệu của tôi
        </v-btn>
      </div>
      <div class="flex xs12 pl-3 nav__btn__custom">
        <v-btn block flat class="mx-0 my-0 px-0" v-on:click.native="filterDocFileChangeBTN('share')">
          <i aria-hidden="true" class="fa fa-share-alt" style="
					width: 27px;
					height: 15px;
				"></i>
        Tài liệu được chia sẻ
        </v-btn>
      </div>
      
    </div>
  </v-slide-x-transition>
</div>

<!-- TODO paymentViewJX template one page -->
<div id="paymentViewJX_form_template" class="hidden">
  <!-- TODO: show detail -->
  <div class="jx-content-wrap layout wrap">

    <div class="flex xs6" :class="{'max-width': !currentListPage, 'no-width': currentListPage}">

      <#include "detail.ftl">

    </div>

    <div class="flex xs6" :class="{'no-width': !currentListPage, 'max-width': currentListPage}">

      <v-slide-x-transition>
        <div class="layout wrap" v-if="currentListPage">

          <div class="row-header flex-break" v-if="!keywordsSearchable">
            <div class="flex" style="min-width:50%;max-width:50%">
              <div v-show="!isSearch">
                <v-breadcrumbs class="py-2" v-if="breadWorkspace">
                  <v-icon slot="divider" style="color: #ffffff!important">chevron_right</v-icon>
                  <v-breadcrumbs-item v-for="item in workspaceTree" :key="item.id" v-on:click.native="breadcrumbsSelected(item)">
                    {{ item.name }}
                  </v-breadcrumbs-item>
                </v-breadcrumbs>
                <v-breadcrumbs class="py-2" v-if="!breadWorkspace&&!viewFirst">
                  <span v-show="txtPersonShare" class="txtPersonShare"></span>
                  <v-icon slot="divider" v-show="!txtPersonShare" style="color: #ffffff!important">chevron_right</v-icon>
                  <v-breadcrumbs-item v-show="!txtPersonShare" v-for="item in docFileTemplateTree" :key="item.id" v-on:click.native="breadcrumbsSelectedDocTEMP(item)">
                    {{ item.name }}
                  </v-breadcrumbs-item>
                </v-breadcrumbs>
              </div>
              <div v-show="viewFirst" class="pl-2">Thư mục lưu trữ</div>
              <div v-show="isSearch" class="pl-2">Kết quả tìm kiếm</div>
            </div>
            <!-- Search -->
            <div class="flex w-100-xs" style="
						  display: flex;
						  display: -webkit-flex;
						  align-items: center"
					  >
              <v-btn flat icon v-on:click.native="toDetailDocFile(docFileTempID)" class="my-0 mx-0" 
              v-if="docFileTemplateTree.length > 0 && !breadWorkspace && docFileTempID > 0">
                <v-icon>edit</v-icon>
              </v-btn>
	              
              <div class="flex w-100-xs finder-keywords-search" jx-bind="keywordsSearch" style="display: flex;display: -webkit-flex;">
              </div>
            </div>
            <!-- Search advanced -->
            <v-menu left :close-on-content-click="false" :nudge-left="200" :nudge-bottom="2" v-model="menu">
              <v-btn flat slot="activator">Tìm kiếm nâng cao</v-btn>
              <v-card>
                <v-list>
                  <v-list-tile>
                    <v-list-tile-content>
                      <v-list-tile-sub-title>Tìm kiếm nâng cao</v-list-tile-sub-title>
                    </v-list-tile-content>
                  </v-list-tile>
                </v-list>
                <v-divider class="my-0"></v-divider>
                <v-layout wrap class="px-3">
                  <div class="flex xs12" jx-bind="documentCatFilter"></div>
      				    <div class="flex xs12" jx-bind="labelFilter"></div>
                </v-layout>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn flat @click="menu = false">Quay lại</v-btn>
                  <v-btn color="primary" flat @click="menu = false">Tìm kiếm</v-btn>
                </v-card-actions>
              </v-card>
            </v-menu>

          </div>

          <v-slide-y-transition>
            <div class="row-header flex-break my-0" v-if="keywordsSearchable">

              <v-toolbar scroll-off-screen class="my-0 row-header">
                <v-btn icon v-on:click.native="keywordsSearchable = !keywordsSearchable" class="my-0">
                  <v-icon>arrow_back</v-icon>
                </v-btn>

              </v-toolbar>

            </div>
          </v-slide-y-transition>
          <!-- Content Right -->
          <v-slide-y-transition>
            <div class="mb-2 folder__expand__view pt-2" v-if="khoDuLieuListFolderItems.length > 0 && !isSearch">

              <ul class="display-style-icon row">
                <li class="lfr-asset-folder" v-for="(item, index) in khoDuLieuListFolderItems">
                  <div class="card mt-2 mb-0">
                    <div>
                      <div class="card-col-field">
                        <div class="sticker sticker-lg sticker-static">
                          <v-icon class="icon__folder">folder</v-icon>
                        </div>
                      </div>
                      <div class="card-col-content card-col-gutters" style="cursor: pointer;" @click="previewAttachPDFTab(item)" v-if="item.name.length > 25">
                        <span class="truncate-text">
                          <v-tooltip top>
                            <span slot="activator">{{item.name}}</span>
                            <span>{{item.name}}</span>
                          </v-tooltip>
                        </span>
                      </div>
                      
                      <div class="card-col-content card-col-gutters" style="cursor: pointer;" @click="previewAttachPDFTab(item)" v-else>
                        <span class="truncate-text">
                          <span>{{item.name}}</span>
                        </span>
                      </div>

                      <div class="card-col-field lfr-card-actions-column pr-3" v-if="item.editable">
                      	<v-menu transition="slide-x-transition" full-width>
                      		<v-btn flat icon class="mx-0 my-0" slot="activator">
	                          <v-icon>settings</v-icon>
	                        </v-btn>
                          <v-list>
                            <v-list-tile @click="toWorkspaceEdit(item, index)">
                              <v-list-tile-title>
                                Sửa
                              </v-list-tile-title>
                            </v-list-tile>
                            <v-list-tile @click="toWorkspaceDelete(item, index)">
                              <v-list-tile-title>
                                Xoá
                              </v-list-tile-title>
                            </v-list-tile>
                          </v-list>
                        </v-menu>
                      </div>
                    </div>
                  </div>
                </li>
              </ul>
            </div>
          </v-slide-y-transition>

          <v-slide-y-transition>
            <div style="width: 100%;">
              <div v-if="khoDuLieuListFolderItems.length > 0" class="mb-2">
              </div>
              <div v-if="!no_list_access && khoDuLieuListFolderItems.length > 0 ">
              	Tài liệu: 
                <br>
              </div>
              <div v-if="!no_list_access" class="layout wrap" jx-bind="khoDuLieuList">

              </div>
            </div>
          </v-slide-y-transition>

        </div>

      </v-slide-x-transition>
    </div>
  </div>
</div>

<!-- TODO paymentViewJX template one page view List detail template/ Danh sách -->
<div id="activity_expand_list_template" class="hidden">
  <template slot="items" slot-scope="props">

    <td class="text-xs-left px-2" style="padding-top: 2px">
    	<v-btn v-if="(props.item.permanent == true && props.item.permission === 'owner') || (props.item.permanent == '' && props.item.permission === 'owner')" icon class="mx-0 my-0">
          <v-icon>check_box</v-icon>
        </v-btn>
    	<v-btn v-else icon class="mx-0 my-0">
          <i aria-hidden="true" class="fa fa-share-alt"></i>
        </v-btn>
    	<a href="javascript:;" @click.stop.prevent="toDetailDocFile(props.item.docFileId)">
        {{ props.item.codeNo }} / {{ props.item.codeNotation }}
      </a>
      
    </td>

    <td class="text-xs-center px-2" style="padding-top: 10px;">
    	<a href="javascript:;" @click.stop.prevent="toDetailDocFile(props.item.docFileId)">
        {{ props.item.promulgationDate | date }}
      </a>
      
    </td>
    <td class="text-xs-left px-2" style="padding-top: 10px;">
      <a href="javascript:;" @click.stop.prevent="toDetailDocFile(props.item.docFileId)">
        {{ props.item.name }}
      </a>
    </td>
    <td class="text-xs-center px-2" style="
		    align-items: center;
		    border: 0;
		">

      <v-btn icon class="mx-0 my-0" :loading="downloading === props.item.docFileId" v-on:click.native="downloadDocFileReferent(props.item)"
        :disabled="downloading === props.item.docFileId">
        <v-icon>file_download</icon>
      </v-btn>
      <v-btn icon v-on:click.native="toRemoveDocFile(props.item, props.index)" class="mx-0 my-0" v-if="(props.item.permanent && props.item.permission === 'owner') || (props.item.permanent.length == 0 && props.item.permission === 'owner')">
        <v-icon color="red darken-3">clear</v-icon>
      </v-btn>
      <v-btn icon v-on:click.native="toRemoveFileLink(props.item, props.index)" class="mx-0 my-0" v-if="(props.item.permanent == false && props.item.permission === 'write' || props.item.permanent == false && props.item.permission === 'owner') && props.item.permanent.length > 0">
        <v-icon color="red darken-3">clear</v-icon>
      </v-btn>
      
    </td>
  </template>
</div>

<div id="popUpEditWorkspaceTemplate">
  <div class="layout wrap flex xs12 text-center pt-4">

    <div class="flex pr-3 w-100-xs" jx-bind="workspaceName"></div>

    <div class="flex pr-3 w-100-xs" jx-bind="workspaceSibling"></div>

    <div class="flex xs12 mobilink-shared-root editable-wrap editable-wrap-before-select" jx-bind="parentWorkspace"></div>
    <div class="flex xs12">
      <v-alert outline color="error" icon="warning" :value="apistate1 === 2">
        Lỗi cập nhật dữ liệu!
      </v-alert>
    </div>
    <div class="flex xs12">
      <jx-mobilink-share-select item-text="fullName" item-value="userId" :items="workspaceUserItems" label="Người được phép truy cập"
        v-model="workspaceUser" ref="workspaceUser"></jx-mobilink-share-select>
      <v-alert outline color="error" icon="warning" :value="apistate2 === 2">
        Lỗi cập nhật phân quyền người có tài khoản!
      </v-alert>
    </div>

    <div class="flex xs12">
      <jx-mobilink-share-select item-text="roleName" item-value="roleId" :items="workspaceRoleItems" label="Chức vụ được phép truy cập"
        v-model="workspaceRole" ref="workspaceRole"></jx-mobilink-share-select>
      <v-alert outline color="error" icon="warning" v-if="apistate3 === 2">
        Lỗi cập nhật phân quyền chức vụ!
      </v-alert>
      <v-alert outline color="success" icon="check_circle" :value="apistate3 === 1 && apistate2 === 1 && apistate1 === 1">
        Yêu cầu của bạn được thực hiện thành công!
      </v-alert>
    </div>

  </div>
</div>
<!-- Form thêm mới -->
<div id="popUpEditDocFileTemplate">
  <div class="layout wrap flex xs12 text-center pt-4 mt-3">

    <div class="flex pr-3 w-100-xs" v-if="is_add_form">
    	<jx-mobilink-docfile-add
    		:class_name="class_name_doc"
			:class_pk="class_pk"
			:group_id="groupId"
			is_template="false"
			is_upload="true"
			file_attach_api="/o/v2/mobilink/fileattachs"
			ref="uploadcom1"
			@call-back="successCallBack"
			:workspace_cur="workspace_curId"
			:current_user_id="current_user_id"
    	></jx-mobilink-docfile-add>
    </div>

  </div>
</div>
<!-- Form sửa -->
<div id="popUpEditDocFileTempTemplate">
  <div class="layout wrap flex xs12 text-center pt-4 mt-3">

    <div class="flex pr-3 w-100-xs" v-if="!is_add_form">
    	<jx-mobilink-docfile-add
    		:class_name="class_name_doc"
			:class_pk="class_pk"
			:group_id="groupId"
			is_template="true"
			is_upload="false"
			file_attach_api="/o/v2/mobilink/fileattachs"
			ref="uploadcom2"
			@call-back="successCallBack"
			:workspace_cur="workspace_curId"
			:current_user_id="current_user_id"
    	></jx-mobilink-docfile-add>
    </div>

  </div>
</div>

<div id="khoTuLieuViewJX" :class="{'nav_drawn_width_none': !currentListPage}"></div>

<script type="text/javascript">
  document.addEventListener('DOMContentLoaded', function(event) {
    var config = {
      headers: {
        'groupId': themeDisplay.getScopeGroupId()
      }
    };
    var config_blob = {
      headers: {
        'groupId': themeDisplay.getScopeGroupId()
      },
      responseType: 'blob'
    };
    var khoTuLieuViewJX = new VueJX({
      el: 'khoTuLieuViewJX',
      pk: 1,
      groupid: themeDisplay.getScopeGroupId(),
      onScroll: 'onScroll',
      data: {
        txtPersonShare: false,
        viewFirst: true,
        isSearch: false,
        workspace_curId: 0,
        codeNocodeNotation_hidden: true,
        codeNocodeNotation_hidden_loading: false,
        templateNosubject_hidden: true,
        templateNosubject_hidden_loading: false,
        subject_hidden: true,
        subject_hidden_loading: false,
        tempData1: '',
        tempData2: '',
      	no_list_access: true,
      	docFileTempID: 0,
        breadWorkspace: false,
        is_add_form: true,
        fav: true,
        menu: false,
        message: false,
        hints: true,
        downloading: -1,
        detailShowMore: false,
        apistate3: 0,
        apistate2: 0,
        apistate1: 0,
        class_name: 'org.mobilink.sharing.model.Workspace',
        class_name_doc: 'org.mobilink.docmgt.model.DocFile',
        class_pk: 0,
        current_user_id: themeDisplay.getUserId(),
        current_user_name: themeDisplay.getUserName(),
        groupId: themeDisplay.getScopeGroupId(),
        options: {
          target: '/o/v2/mobilink/fileattachs/upload',
          chunkSize: 100*1024*1024,
          headers: {
          	'groupId': themeDisplay.getScopeGroupId()
          }
        },
        workspaceRoleItems: [],
        workspaceUserItems: [],
        workspaceUser: [],
        workspaceRole: [],
        docFileDetail: {},
        detailModel: {
          docFileId: 0,
          createdDate: 'default',
          modifiedDate: 'default',
          fullname: 'default',
          email: 'default',
          fileName: 'default',
          fileType: 'default',
          fileSize: 0,
          version: 'default',
          source: 'default',
          sourceUrl: 'default',
          docFileId: 0,
          workspaceId: 0,
          name: 'default',
          parentId: 0,
          seqOrder: 'default',
          level: 0,
          treeIndex: 'default',
          accessible: false,
          action: 'folder',
          action_active: 'folder_open',
          id: 0,
          title: 'default',
          active: true
        },
        keywordsSearchable: false,
        currentIndex: -1,
        kho_title_table: 'Danh sach',
        menuSelectItems: [{
          title: "Thêm thư mục",
          id: 1,
          extClass: ""
        }, {
          title: "Thêm tài liệu",
          id: 2,
          extClass: ""
        }, {
          title: "Thêm sổ tài liệu",
          id: 3,
          extClass: "hidden_fak_temp"
        }],
        workspaceTree: [],
        docFileTemplateTree: [],
        valid: false,
        currentListPage: true,
        endPoint: '/o/v2/mobilink/',
        headers: {
          groupId: themeDisplay.getScopeGroupId()
        },
        khoDuLieuListFolderItems: [],
        statusItems: [{
            'value': 0,
            'text': 'Không phải xử lý'
          },
          {
            'value': 1,
            'text': 'Đang xử lý'
          },
          {
            'value': 2,
            'text': 'Hoàn thành xử lý'
          }
        ],
        contacts:[]
      },
      schema: {
        /** TODO menu filter */
        'navigationFilter': {
          'id': 'navigationFilter',
          'name': 'navigationFilter',
          'type': 'navigation',
          'template': 'menu_template',
          'template_content': 'paymentViewJX_form_template',
          'onLoad': '_doRouter',
          'events': {
			      onScroll: function(e) {},
            _doRouter: function() {
              this.detailModel['workspaceId'] = ${Request.workspaceIdW};
              this.toDetailDocFile(${Request.docFileId});
              this.initContacts();
            },
            initComment: function(prevewConfig) {
              $('#mobilink-comments-container').comments(prevewConfig);
            },
            initContacts: function(){
              var vm = this
              var url = vm.endPoint + 'contacts?contactType=0';
                axios.get(url, config).then(function (response) {
                    var serializable = response.data;

                    if (serializable.hasOwnProperty('data')) {
                        var arrTemp = []
                        for (var key in serializable.data) {
                            arrTemp.push({
                                id : serializable.data[key].contactId,
                                fullname : serializable.data[key].fullName,
                                email : serializable.data[key].email,
                                profilePictureURL : serializable.data[key].profileUrl
                            })
                        }
                        vm.contacts = arrTemp;
                    } else {
                      vm.contacts = [];
                    }
                })
                .catch(function (error) {
                    vm.contacts = [];
                })
            
            },
            previewAlpacaJsFormFunc: function (prevewConfig) {
            	console.log(prevewConfig);
            	console.log(prevewConfig.formscript);
	            var alpacaJs = {};
	            if (prevewConfig.formscript.startsWith('{')) {
	               alpacaJs = eval('(' + prevewConfig.formscript + ')');
	            };
	            $(prevewConfig.id).alpaca("destroy");
	            
	            setTimeout(
                function() {
                  $(prevewConfig.id).alpaca(alpacaJs);
                },
                1000);
	          },
	          submitFormOnlineData: function (dataConfig) {
	          	var control = $(dataConfig.id).alpaca("get");
	          	this.alpacaSubmit(dataConfig, JSON.stringify(control.getValue()));
	          },
	          codeNocodeNotationTempleDataEvent: function(data) {
	          	this.tempData1 = data.codeNo;
	          	this.tempData2 = data.codeNotation;
	          	this.tempData3 = data.seqNum;
	          	this.codeNocodeNotation_hidden = !this.codeNocodeNotation_hidden;
	          },
	          codeNocodeNotationRolbackEvent: function(data) {
	          	data.codeNo = this.tempData1;
	          	data.codeNotation = this.tempData2;
	          	data.seqNum = this.tempData3;
	          	this.codeNocodeNotation_hidden = !this.codeNocodeNotation_hidden;
	          },
	          codeNocodeNotationUpdateEvent: function(item) {
	          	var vm = this; 
	          	var validator = document.querySelector(".editable-wrap .error--text"); 
	          	var dataToAPI = new URLSearchParams();
	          	dataToAPI.append("codeNo", vm.docFileDetail.codeNo);
	          	dataToAPI.append("codeNotation", vm.docFileDetail.codeNotation);
	          	if (item.register == 2) {
	          		dataToAPI.append("seqNum", vm.docFileDetail.seqNum);
	          	}
	          	if(validator == null) {
	          		var url = '/o/v2/mobilink/docfiles/' +vm.docFileDetail.docFileId ;
	          		axios.put(url, dataToAPI, config).then(function(response) {
	          			vm.snackbartextkhoTuLieuViewJX = "Cập nhật dữ liệu thành công!";
                    vm.snackbarkhoTuLieuViewJX = true;
                    vm.codeNocodeNotation_hidden = !vm.codeNocodeNotation_hidden;
                  })
                  .catch(function(error) {
                    console.log(error);
                    vm.snackbartextkhoTuLieuViewJX = "Cập nhật dữ liệu thất bại!";
                    vm.snackbarerorkhoTuLieuViewJX = true;
                  });
	          	}
	          },
	          templateNosubjectTempleDataEvent: function(data) {
	          	this.tempData1 = data.templateNo;
	          	this.tempData2 = data.subject;
	          	this.templateNosubject_hidden = !this.templateNosubject_hidden;
	          },
	          templateNosubjectRolbackEvent: function(data) {
	          	data.templateNo = this.tempData1;
	          	data.subject = this.tempData2;
	          	this.templateNosubject_hidden = !this.templateNosubject_hidden;
	          },
	          templateNosubjectUpdateEvent: function() {
	          	var vm = this; 
	          	var validator = document.querySelector(".editable-wrap .error--text"); 
	          	var dataToAPI = new URLSearchParams();
	          	dataToAPI.append("templateNo", vm.docFileDetail.templateNo);
	          	dataToAPI.append("subject", vm.docFileDetail.subject);
	          	if(validator == null) {
	          		var url = '/o/v2/mobilink/docfiles/' +vm.docFileDetail.docFileId ;
	          		axios.put(url, dataToAPI, config).then(function(response) {
	          			vm.snackbartextkhoTuLieuViewJX = "Cập nhật dữ liệu thành công!";
	                    vm.snackbarkhoTuLieuViewJX = true;
	                    vm.templateNosubject_hidden = !vm.templateNosubject_hidden;
	                  })
	                  .catch(function(error) {
	                    console.log(error);
	                    vm.snackbartextkhoTuLieuViewJX = "Cập nhật dữ liệu thất bại!";
	                    vm.snackbarerorkhoTuLieuViewJX = true;
	                  });
	          	}
	          },
	          subjectTempleDataEvent: function(data) {
	          	this.tempData2 = data.subject;
	          	this.subject_hidden = !this.subject_hidden;
	          },
	          subjectRolbackEvent: function(data) {
	          	data.subject = this.tempData2;
	          	this.subject_hidden = !this.subject_hidden;
	          },
	          subjectUpdateEvent: function() {
	          	var vm = this; 
	          	var validator = document.querySelector(".editable-wrap .error--text"); 
	          	var dataToAPI = new URLSearchParams();
	          	dataToAPI.append("subject", vm.docFileDetail.subject);
	          	if(validator == null) {
	          		var url = '/o/v2/mobilink/docfiles/' +vm.docFileDetail.docFileId ;
	          		axios.put(url, dataToAPI, config).then(function(response) {
	          			vm.snackbartextkhoTuLieuViewJX = "Cập nhật dữ liệu thành công!";
	                    vm.snackbarkhoTuLieuViewJX = true;
	                    vm.subject_hidden = !vm.subject_hidden;
	                  })
	                  .catch(function(error) {
	                    console.log(error);
	                    vm.snackbartextkhoTuLieuViewJX = "Cập nhật dữ liệu thất bại!";
	                    vm.snackbarerorkhoTuLieuViewJX = true;
	                  });
	          	}
	          }
          }
        },
        'workspace0Filter': {
          'id': 'workspace0Filter',
          'name': 'workspace0Filter',
          'type': 'treeview',
          'folder_icon': 'folder',
          "newdatatree": "newdatatree",
          "datatree": "datatree",
          "onLoad": "_initworkspace0Filter",
          "toggle_item": "filterChange",
          'events': {
            onScroll: function() {},
            /** click vao lua chon: them thu muc | them file */
            menuSelect: function(id) {
              var vm = this;
                vm.currentListPage = true;
                if (id === 1) {
                	vm.khoTuLieuViewJXTitle = "Thêm mới ngăn thư mục";
                	vm.popUpEditWorkspace = !vm.popUpEditWorkspace;
                	vm.workspaceId = 0;
	                if (!vm._initPopup) {
	                  vm._initParentWorkspaceData();
	                  vm._initPopup = true;
	                }
	                var parentWorkspaceStr = 0;
	                if (vm.workspaceTree.slice(-1)[0]) {
	                	parentWorkspaceStr = vm.workspaceTree.slice(-1)[0].workspaceId;
	                }
	                vm.parentWorkspace = parentWorkspaceStr;
	                vm._initworkspaceRoleData();
	                vm._initworkspaceUserData();
	                vm.currentIndex = -1;
	                vm.workspaceName = "";
	                var workspaceSiblingStr = 0;
	                if (vm.detailModel['seqOrder'] > 0 && vm.detailModel['seqOrder'] != 'default') {
	                	workspaceSiblingStr = vm.detailModel['seqOrder'];
	                }
	                vm.workspaceSibling = workspaceSiblingStr;
                } else if (id === 2) {
                	vm.khoTuLieuViewJXTitle = "Thêm mới tài liệu";
                	var parentWorkspaceStr = 0;
	                if (vm.workspaceTree.slice(-1)[0]) {
	                	parentWorkspaceStr = vm.workspaceTree.slice(-1)[0].workspaceId;
	                }
                	vm.is_add_form = true;
                	vm.workspace_curId = parentWorkspaceStr;
                	vm.popUpEditDocFile = !vm.popUpEditDocFile;
                } else if (id === 3) {
                	vm.khoTuLieuViewJXTitle = "Thêm mới sổ tài liệu";
                	vm.is_add_form = false;
                	vm.popUpEditDocFileTemp = !vm.popUpEditDocFileTemp;
                }
            },
            /** click vao ten thu muc tren breadcrumb */
            breadcrumbsSelected: function(item) {
              var vm = this;
              vm.setWorkspaceTree(item);
              vm.detailModel = vm.workspaceTree.slice(-1)[0];
              vm._inikhoDuLieuList(null);
            },
            breadcrumbsSelectedDocTEMP: function(item) {
              var vm = this;
              vm.setWorkspaceTree(item);
              vm.detailModel = vm.workspaceTree.slice(-1)[0];
              vm._inikhoDuLieuList(null);
            },
            filterChange: function(config) {
              var vm = this;
              vm.keywordsSearch = "";
              vm.khoDuLieuListpage = 1;
              vm.no_list_access = false;
              vm.breadWorkspace = true;
              vm.viewFirst = false;
              vm.isSearch = false;
              vm.txtPersonShare = false;
              vm.currentListPage = true;
              vm.detailModel = config.item;
              vm.detailModel['workspaceId'] = config.item.id;
              vm.detailModel['parentId'] = config.item.pidNode;
              vm.detailModel['treeIndex'] = config.item.ptype;
              //TODO
              var url = vm.endPoint + 'workspaces';
              axios.get(url + '/' + config.item.id, config).then(function(response) {
                var serializable = response.data;
                vm.detailModel['seqOrder'] = serializable.seqOrder;
                  vm.detailModel['editable'] = serializable.editable;
              })
              .catch(function(error) {
                console.log(error);
              });
              
              vm.setWorkspaceTree(vm.detailModel);
              vm._inikhoDuLieuList(vm.detailModel);
            },
			    /** thuoc tinh cua modelDetail */
            _mapModelDetail: function(model, active) {
              var vm = this;
              for (var key in this.detailModel) {
                switch (key) {
                  case "action":
                    model[key] = "folder";
                    break;
                  case "action_active":
                    model[key] = "folder_open";
                    break;
                  case "id":
                    model[key] = model["workspaceId"] + "_" + model["docFileId"];
                    break;
                  case "title":
                    model[key] = model["name"];
                    break;
                  case "active":
                    model[key] = active;
                    break;
                  default:
                    model[key] = model[key];
                    break;
                }
              };

              if (model.workspaceId == undefined) {
                model.name = model.subject;
              };

              return model;
            },
            /** danh sach breadCrumb - workspace0Filter - table khoDuLieu format: [modelDetail,modelDetail...] */
            _mapListModelDetail: function(models) {
              var vm = this;
              var result = [];
              var active = false;
              for (var i = 0; i < models.length; i++) {
                active = i == 0 ? true : false;
                var m = vm._mapModelDetail(models[i], active);
                result.push(m);
              };
              return result;
            },
			      _initworkspace0Filter: function() {
              /** TODO: call api workspaces?level=0*/
              this.newdatatree = {};
              var vm = this;
              var url = vm.endPoint + 'workspaces';
              axios.get(url + '?parent=0', config).then(function(response) {
                var serializable = response.data;
                var active = true;
                var treeArray = []
                if (serializable.hasOwnProperty('data')) {
                  for (var key in serializable.data) {
                    treeArray.push({
                      "children": [],
                      "name": serializable.data[key].name,
                      "pid": 0,
                      "ptype": serializable.data[key].treeIndex,
                      "id": serializable.data[key].workspaceId,
                      "pidNode": serializable.data[key].parentId,
                      "treeIndex": serializable.data[key].treeIndex,
                      "folder_icon": "folder"
                    });
                  };
                  vm._inikhoDuLieuListTEMP();
                  vm.datatree = new VueTreeList.Tree(treeArray);
                }
              })
              .catch(function(error) {
                console.log(error);
              });
            }
		      }
        },
        'docFileTemplateFilter': {
          'id': 'docFileTemplateFilter',
          'name': 'docFileTemplateFilter',
          'type': 'treeview',
          "datatree": "datatreedocfile",
          "onLoad": "_initdocFileTemplateFilter",
          "toggle_item": "filterDocFileChange",
          'events': {
            filterDocFileChange: function(config) {
              var vm = this;
              vm.no_list_access = false;
              vm.breadWorkspace = false;
              vm.viewFirst = false;
              vm.isSearch = false;
              vm.txtPersonShare = false;
              if (config.item.children != null || config.item.parent.name === 'root') {
              	vm.docFileTempID = 0;
                vm.docFileTemplateTree = [
                  {
                  	id: config.item.id,
                  	name: config.item.name
                  }
                ];
              } else {
              	vm.docFileTempID = config.item.id;
              	vm.docFileTemplateTree = [
                  {
                  	id: config.item.parent.id,
                  	name: config.item.parent.name
                  },
                  {
                  	id: config.item.id,
                  	name: config.item.name
                  }
                ];
              };
              
              vm.currentListPage = true;
              vm.detailModel = config.item;
              vm.detailModel['templateNo'] = config.item.pidNode;
              vm.detailModel['register'] = config.item.ptype;
              vm._inikhoDuLieuList(vm.detailModel);
            },
            filterDocFileChangeBTN: function(data) {
              var vm = this;
              vm.keywordsSearch = "";
              vm.breadWorkspace = false;
              vm.viewFirst = false;
              vm.isSearch = false;
              vm.txtPersonShare = true;
              vm.khoDuLieuListpage = 1;
              vm.no_list_access = false;
              vm.currentListPage = true;
              vm.detailModel = {};
              vm.detailModel['register'] = "";
              if (data === 'me') {
                setTimeout(function(){
                  $('.row-header .txtPersonShare')[0].innerHTML = "Tài liệu của tôi";
                },100)
              	vm.detailModel['userId'] = themeDisplay.getUserId();
              } else if (data === 'share') {
                setTimeout(function(){
                  $('.row-header .txtPersonShare')[0].innerHTML = "Tài liệu được chia sẻ";
                },100)
                vm.detailModel['me'] = true;
              	vm.detailModel['userId'] = 0;
              }
              vm._inikhoDuLieuList(vm.detailModel);
            },
            _initdocFileTemplateFilter: function() {
              var vm = this;
              var url = vm.endPoint + 'docfiles';
              var arrayRegister = [{
                  "children": [],
                  "name": "Không xác định",
                  "pid": 0,
                  "ptype": 0,
                  "id": 0,
                  "pidNode": "",
                  "folder_icon": "assignment",
                  "parent": null
                },{
                  "children": [],
                  "name": "Tài liệu đi",
                  "pid": 0,
                  "ptype": 1,
                  "id": 1,
                  "pidNode": "",
                  "folder_icon": "assignment",
                  "parent": null
                },
                {
                  "children": [],
                  "name": "Tài liệu đến",
                  "pid": 0,
                  "ptype": 2,
                  "id": 2,
                  "pidNode": "",
                  "folder_icon": "assignment",
                  "parent": null
                }
              ];
              axios.all([
                axios.get(url + '?register=0&template=1&sort=subject', config),
                axios.get(url + '?register=1&template=1&sort=subject', config),
                axios.get(url + '?register=2&template=1&sort=subject', config)
              ])
              .then(axios.spread(function(urlRespones, url1Respones, urlFilesRespones) {
                // Both requests are now complete
                var serializable = urlRespones.data;
                var serializable1 = url1Respones.data;
                var serializable2 = urlFilesRespones.data;
                if (serializable.hasOwnProperty('data')) {
                  for (var key in serializable.data) {
                    arrayRegister[0].children.push({
                      "name": serializable.data[key].subject,
                      "pid": 0,
                      "ptype": 0,
                      "id": serializable.data[key].docFileId,
                      "pidNode": serializable.data[key].templateNo,
                      "folder_icon": "description",
                      "parent": {
                        "name": "Tài liệu đi",
                        "pid": 0,
                        "ptype": 0,
                        "id": 0,
                        "pidNode": "",
                        "folder_icon": "assignment"
                      }
                    });
                  };
                } else {
                  arrayRegister[0].children = [];
                };
                if (serializable1.hasOwnProperty('data')) {
                  for (var key in serializable1.data) {
                    arrayRegister[1].children.push({
                      "name": serializable1.data[key].subject,
                      "pid": 0,
                      "ptype": 1,
                      "id": serializable1.data[key].docFileId,
                      "pidNode": serializable1.data[key].templateNo,
                      "folder_icon": "description",
                      "parent": {
                        "name": "Tài liệu đi",
                        "pid": 0,
                        "ptype": 1,
                        "id": 1,
                        "pidNode": "",
                        "folder_icon": "assignment"
                      }
                    });
                  };
                } else {
                  arrayRegister[1].children = [];
                };
                if (serializable2.hasOwnProperty('data')) {
                  for (var key in serializable2.data) {
                    arrayRegister[2].children.push({
                      "name": serializable2.data[key].subject,
                      "pid": 0,
                      "ptype": 2,
                      "id": serializable2.data[key].docFileId,
                      "pidNode": serializable2.data[key].templateNo,
                      "folder_icon": "description",
                      "parent": {
                        "name": "Tài liệu đến",
                        "pid": 0,
                        "ptype": 2,
                        "id": 2,
                        "pidNode": "",
                        "folder_icon": "assignment"
                      }
                    });
                  };
                } else {
                  arrayRegister[2].children = [];
                };
                vm.datatreedocfile = new VueTreeList.Tree(arrayRegister);
              })).catch(function(error) {
                console.log(error);
              });
            }
          }
        },
        /** TODO filter component */
        "documentCatFilter": {
          'id': 'documentCatFilter',
          'name': 'documentCatFilter',
          "type": "select",
          'label': 'Loại văn bản',
          "item_text": "name",
          "item_value": "workspaceId",
          "single_line": true,
          "hide_selected": true,
          "multiple": false,
          "tags": false, //custom input not avaliable in select
          "chips": true,
          "loading": false,
          "no_data_text": "Lua chon selected",
          "items": [],
          "onChange": "filterTableDocCat($event)",
          "onRemove": "filterTableDocCatOnRemove",
          'onClick': 'filterTableDocCatOnClear',
          "events": {
            _initDocumentCatFilterData: function() {
              var vm = this;
              var url = vm.endPoint + 'workspaces';
              axios.get(url, config).then(function(response) {
                  var serializable = response.data;
                  if (serializable.hasOwnProperty('data'))
                    vm.documentCatFilterItems = serializable.data;
                })
                .catch(function(error) {
                  console.log(error);
                });
            },
            filterTableDocCat: function(data) {
              var vm = this;
              vm.documentCatFilter = data;
              vm._inikhoDuLieuList(null);
            },
            filterTableDocCatOnRemove: function() {
              var vm = this;
              vm.documentCatFilter = [];
              vm._inikhoDuLieuList(null);
            },
            filterTableDocCatOnClear: function() {
              this.documentCatFilter = [];
            }
          }
        },
        "labelFilter": {
          'id': 'labelFilter',
          'name': 'labelFilter',
          "type": "select",
          'label': 'Thẻ nhãn ',
          "item_text": "name",
          "item_value": "workspaceId",
          "single_line": true,
          "hide_selected": true,
          "multiple": false,
          "tags": false, //custom input not avaliable in select
          "chips": true,
          "loading": false,
          "no_data_text": "Lua chon selected",
          "items": [],
          'onChange': 'filterTableLabel($event)',
          "onRemove": "filterTableLabelOnRemove",
          'onClick': 'filterTableLabelOnClear',
          "events": {
            _initlabelFilterData: function() {
              var vm = this;
              var url = vm.endPoint + 'workspaces';
              axios.get(url, config).then(function(response) {
                  var serializable = response.data;
                  if (serializable.hasOwnProperty('data')) {
					  vm.labelFilterItems = serializable.data;
				  }
                })
                .catch(function(error) {
                  console.log(error);
                });
            },
            filterTableLabel: function(data) {
              var vm = this;
              vm.labelFilter = data;
              vm._inikhoDuLieuList(null);
            },
            filterTableLabelOnRemove: function() {
              var vm = this;
              vm.labelFilter = [];
              vm._inikhoDuLieuList(null);
            },
            filterTableLabelOnClear: function() {
              this.labelFilter = [];
            }
          }
        },
        'keywordsSearch': {
          'id': 'keywordsSearch',
          'name': 'keywordsSearch',
          'type': 'text',
          'placeholder': 'Nhập từ khoá',
          'solo': true,
          'append_icon': 'search',
          'onKeyup': 'filterTableKeywords',
          'events': {
            filterTableKeywords: function(event) {
              var vm = this;
              if (event.keyCode === 13) {
                vm.detailModel['workspaceId'] = -1;
                vm.khoDuLieuListpage = 1;
                if (vm.keywordsSearch.length > 0) {
                  vm.isSearch = true;
                }
                vm._inikhoDuLieuList(null);
              }
            }
          }
        },
        /** form edit*/
        'workspaceName': {
          'id': 'workspaceName',
          'name': 'workspaceName',
          'type': 'text',
          'required': true,
          'placeholder': 'Tên thư mục '
        },
        'workspaceSibling': {
          'id': 'workspaceSibling',
          'name': 'workspaceSibling',
          'type': 'number',
          'placeholder': 'Số thứ tự'
        },
        "parentWorkspace": {
          'id': 'parentWorkspace',
          'name': 'parentWorkspace',
          "type": "select",
          'label': 'Thư mục cha ',
          "item_text": "name",
          "item_value": "workspaceId",
          "hide_selected": true,
          "chips": true,
          "loading": false,
          "no_data_text": "Lua chon selected",
          "items": [],
          "events": {
            _initParentWorkspaceData: function() {
              var vm = this;
              var url = vm.endPoint + 'workspaces';
              axios.get(url, config).then(function(response) {
                  var serializable = response.data;
                  if (serializable.hasOwnProperty('data')) {
                    vm.parentWorkspaceItems = serializable.data;
                    vm.parentWorkspaceItems.unshift({
                      'workspaceId': 0,
                      'name': 'Thư mục gốc'
                    });
                  }
                })
                .catch(function(error) {
                  console.log(error);
                });
            },
            _initworkspaceUserData: function() {
              var vm = this;
              vm.workspaceSibling = 0;
              var url = vm.endPoint + 'resourceusers' + '/org.mobilink.sharing.model.Workspace/' + vm.workspaceId + '?sort=fullName';
              var paramsBuilder = {
                active: true,
                sort: 'fullName',
                order: true
              };
              var configWorkspace = {
                params: paramsBuilder,
                headers: vm.headers
              };
              vm.workspaceUser = [];
              axios.get(url, configWorkspace).then(function(response) {
                  var serializable = response.data;
                  if (serializable.hasOwnProperty('data')) {
                    vm.workspaceUserItems = serializable.data;
                    for (var key in vm.workspaceUserItems) {
                      if (vm.workspaceUserItems[key].hasOwnProperty('selected') && vm.workspaceUserItems[key]['selected'] === true) {
                        vm.workspaceUser.push(vm.workspaceUserItems[key]);
                      };
                    };
                    vm.$refs['workspaceUser'].inputVal = vm.workspaceUser;
                  };
                })
                .catch(function(error) {
                  console.log(error);
                });
            },
            _initworkspaceRoleData: function() {
              var vm = this;
              var url = vm.endPoint + 'resourceroles' + '/org.mobilink.sharing.model.Workspace/' + vm.workspaceId + '?sort=roleName&full=true';
              vm.workspaceRole = [];
              axios.get(url, config).then(function(response) {
                  var serializable = response.data;
                  if (serializable.hasOwnProperty('data')) {
                    vm.workspaceRoleItems = serializable.data;
                    for (var key in vm.workspaceRoleItems) {
                      if (vm.workspaceRoleItems[key].hasOwnProperty('selected') && vm.workspaceRoleItems[key]['selected'] === true) {
                        vm.workspaceRole.push(vm.workspaceRoleItems[key]);
                      };
                    };
                    vm.$refs['workspaceRole'].inputVal = vm.workspaceRole;
                  };
                })
                .catch(function(error) {
                  console.log(error);
                });
            }
          }
        },
        /** table kho du lieu */
        'khoDuLieuList': {
          'id': 'khoDuLieuList',
          'name': 'khoDuLieuList',
          'type': 'table',
          'cssClass': 'danhSachPaymentTable__class',
          'item_key': 'id',
          'headers': 'headers',
          'no_data_text': 'Không có tài liệu',
          'template': 'activity_expand_list_template',
          'pagging': '_khoDuLieuListTable',
          'events': {
            downloadDocFileReferent: function(item) {
              var vm = this;
              vm.downloading = item.docFileId;
              var url = '/o/v2/mobilink/docfiles/' + item.docFileId + '/download';
              axios.get(url, config_blob).then(function(response) {
                  // var url = window.URL.createObjectURL(response.data);
                  // window.open(url);
                  var fileName = response.headers['content-disposition'];
                  fileName = fileName.split('"')[1];
                  var a = document.createElement("a");
                  document.body.appendChild(a);
                  a.style = "display: none";
                  var url = window.URL.createObjectURL(response.data)
                  a.href = url;
                  a.download = fileName;
                  a.click();
                  window.URL.revokeObjectURL(url);
                  //  
                  vm.downloading = -1;
                })
                .catch(function(error) {
                  console.log(error);
                  vm.downloading = -1;
                });
            },
            _khoDuLieuListTable: function() {
              this._inikhoDuLieuList(null);
            },
			      _inikhoDuLieuList: function(item) {
              var vm = this;
              vm.khoDuLieuListheaders = [{
                  text: 'Số ký hiệu',
                  align: 'center',
                  sortable: false,
                  value: 'codeNotation'
                },
                {
                  text: 'Ngày ban hành',
                  align: 'center',
                  sortable: false,
                  value: 'promulgationDate'
                },
                {
                  text: 'Trích yếu',
                  align: 'center',
                  sortable: false,
                  value: 'name'
                },
                {
                  text: '',
                  align: 'left',
                  sortable: false,
                  value: ''
                }
              ];
              
              var workspaceVal = "";
              if (vm.detailModel.workspaceId > 0) {
              	workspaceVal = vm.detailModel.workspaceId;
              }
              var paramsBuilder = {
                keyword: vm.keywordsSearch,
                parent: workspaceVal,
                document: vm.documentCatFilter.workspaceId,
                label: vm.labelFilter.workspaceId
              };
              var configKhoDuLieu = {
                params: paramsBuilder,
                headers: vm.headers
              };
              
              var permissionPar = "";
              if (vm.detailModel['me']) {
              	permissionPar = "follow";
              }
              if (vm.detailModel['userId'] > 0) {
              	permissionPar = "owner";
              }
              var paramsDocFileBuilder = {
                keywords: vm.keywordsSearch,
                workspace: workspaceVal,
                template: 0,
                permission: permissionPar,
                register: vm.detailModel.register,
                templateNo: vm.detailModel.templateNo,
                start: vm.khoDuLieuListpage * 15 - 15,
                end: vm.khoDuLieuListpage * 15,
                sort: 'createDate',
                order: true
              };
              var configDocFile = {
                params: paramsDocFileBuilder,
                headers: vm.headers
              };
              var url = vm.endPoint + 'workspaces';
              var url2 = vm.endPoint + 'docfiles';
			        axios.all([
                axios.get(url, configKhoDuLieu),
                axios.get(url2, configDocFile)
              ])
              .then(axios.spread(function(urlRespones, urlFilesRespones) {
                // Both requests are now complete
                var serializable = urlRespones.data;
                var serializable2 = urlFilesRespones.data;
                if (serializable.hasOwnProperty('data') && !vm.isSearch) {
                  vm.khoDuLieuListFolderItems = vm._mapListModelDetail(serializable.data);
                  if (item != null && !item.hasOwnProperty('register')) {
                    var treeArray = [];
                    for (var key in serializable.data) {
                      treeArray.push({
                        "children": [],
                        "name": serializable.data[key].name,
                        "pid": 0,
                        "ptype": serializable.data[key].treeIndex,
                        "id": serializable.data[key].workspaceId,
                        "pidNode": serializable.data[key].parentId,
                        "folder_icon": "folder"
                      });
                    };
                    item['children'] = treeArray;
                  } else if (item != null && item.hasOwnProperty('register')) {
                    vm.khoDuLieuListFolderItems = [];
                  };
                } else {
                  vm.khoDuLieuListFolderItems = [];
                };
                if (serializable2.hasOwnProperty('data')) {
                  vm.khoDuLieuListItems = vm._mapListModelDetail(serializable2.data);
                  vm.khoDuLieuListTotal = Math.ceil(serializable2.total / 15);
                } else {
                  vm.khoDuLieuListItems = [];
                  vm.khoDuLieuListTotal = 0;
                };
              })).catch(function(error) {
                console.log(error);
              });
            },
            viewThumuc: function(){
              var vm = this;
              vm.viewFirst = true;
              vm.isSearch = false;
              vm.breadWorkspace = false;
              vm.detailModel.workspaceId = 0;
              vm._initworkspace0Filter();
              
            },
            _inikhoDuLieuListTEMP: function() {
              var vm = this;
              vm.no_list_access = false;
              vm.khoDuLieuListheaders = [{
                  text: 'Số ký hiệu',
                  align: 'center',
                  sortable: false,
                  value: 'codeNotation'
                },
                {
                  text: 'Ngày ban hành',
                  align: 'center',
                  sortable: false,
                  value: 'promulgationDate'
                },
                {
                  text: 'Trích yếu',
                  align: 'center',
                  sortable: false,
                  value: 'name'
                },
                {
                  text: '',
                  align: 'center',
                  sortable: false,
                  value: ''
                }
              ];
              var workspaceVal = "0";
              if (vm.detailModel.workspaceId > 0) {
              	workspaceVal = vm.detailModel.workspaceId;
              }
              var paramsBuilder = {
                keyword: vm.keywordsSearch,
                parent: workspaceVal,
                document: vm.documentCatFilter.workspaceId,
                label: vm.labelFilter.workspaceId
              };
              var configKhoDuLieu = {
                params: paramsBuilder,
                headers: vm.headers
              };
              var paramsDocFileBuilder = {
                keywords: vm.keywordsSearch,
                workspace: workspaceVal,
                template: 0,
                permission: "",
                register: vm.detailModel.register,
                templateNo: vm.detailModel.templateNo,
                start: vm.khoDuLieuListpage * 15 - 15,
                end: vm.khoDuLieuListpage * 15,
                sort: 'createDate',
                order: true
              };
              var configDocFile = {
                params: paramsDocFileBuilder,
                headers: vm.headers
              };
              var url = vm.endPoint + 'workspaces';
              var url2 = vm.endPoint + 'docfiles';
			        axios.all([
                axios.get(url, configKhoDuLieu),
                axios.get(url2, configDocFile)
              ])
              .then(axios.spread(function(urlRespones, urlFilesRespones) {
                // Both requests are now complete
                  var serializable = urlRespones.data;
                  var serializable2 = urlFilesRespones.data;
                    if (serializable.hasOwnProperty('data')) {
                      vm.khoDuLieuListFolderItems = vm._mapListModelDetail(serializable.data);
                  } else {
                    vm.khoDuLieuListFolderItems = [];
                  };
                  
                  if (serializable2.hasOwnProperty('data')) {
                    vm.khoDuLieuListItems = vm._mapListModelDetail(serializable2.data);
                    vm.khoDuLieuListTotal = Math.ceil(serializable2.total / 15);
                  } else {
                    vm.khoDuLieuListItems = [];
                    vm.khoDuLieuListTotal = 0;
                  };
                  console.log(vm.khoDuLieuListItems.length);
                  console.log(vm.khoDuLieuListFolderItems)
              })).catch(function(error) {
                console.log(error);
              });
            },
            toWorkspaceEdit: function(item, index) {
              var vm = this;
              vm.detailModel = item;
              vm.popUpEditWorkspace = !vm.popUpEditWorkspace;
              vm.workspaceId = item.workspaceId;
              if (!vm._initPopup) {
                vm._initParentWorkspaceData();
                vm._initPopup = true;
              }
              vm.workspaceUser = [];
              vm._initworkspaceUserData();
              vm._initworkspaceRoleData();
              vm.parentWorkspace = item.parentId;
              vm.currentIndex = index;
              vm.workspaceName = item.name;
              vm.workspaceSibling = item.seqOrder;
            },
            toWorkspaceDelete: function (item, index) {
              var vm = this;
              vm.$dialog.confirm('Bạn có muốn xóa ngăn thư mục '+ item.name +'?', {
                html: true,
                loader: true,
                okText: 'Xác nhận',
                cancelText: 'Quay lại',
                animation: 'fade'
              })
              .then(function(dialog){

                var url = vm.endPoint + "workspaces/" + item.workspaceId;
                axios.delete(url, config).then(function (response) {
                  vm.khoDuLieuListFolderItems.splice(index, 1);
                  vm.snackbartextkhoTuLieuViewJX = "Xoá dữ liệu thành công!";
                  vm.snackbarkhoTuLieuViewJX = true;
                  vm.loadingkhoTuLieuViewJX = false;
                })
                .catch(function (error) {
                  console.log(error);
                  vm.snackbartextkhoTuLieuViewJX = "Xoá dữ liệu thất bại!";
                  vm.snackbarerorkhoTuLieuViewJX = true;
                  vm.loadingkhoTuLieuViewJX = false;
                });
                
                dialog.close();
              })
              .catch(function(e){
                console.log(e);
              })
            },
			      toRemoveFile: function(item, index) {
              var vm = this;
              vm.$dialog.confirm('Bạn có muốn xóa file?', {
                html: true,
                loader: true,
                okText: 'Xác nhận',
                cancelText: 'Quay lại',
                animation: 'fade'
              })
              .then(function(dialog) {
                var url = vm.endPoint + "fileattachs/" + item.docFileId;
                axios.delete(url, {
                    headers: vm.headers
                  }).then(function(response) {
                    vm.khoDuLieuListItems.splice(index, 1);
                    vm.snackbartextkhoTuLieuViewJX = "Xoá dữ liệu thành công!";
                    vm.snackbarkhoTuLieuViewJX = true;
                    vm.loadingkhoTuLieuViewJX = false;
                  })
                  .catch(function(error) {
                    console.log(error);
                    vm.snackbartextkhoTuLieuViewJX = "Xoá dữ liệu thất bại!";
                    vm.snackbarerorkhoTuLieuViewJX = true;
                    vm.loadingkhoTuLieuViewJX = false;
                  });
                dialog.close();
              })
              .catch(function(e) {
                console.log(e);
              })
            },
            toRemoveFileLink: function(item, index) {
              var vm = this;
              vm.$dialog.confirm('Bạn có muốn xóa file được chia sẻ này?', {
                html: true,
                loader: true,
                okText: 'Xác nhận',
                cancelText: 'Quay lại',
                animation: 'fade'
              })
              .then(function(dialog) {
                var workspaceVal = "";
                if (vm.detailModel.workspaceId > 0) {
                  workspaceVal = vm.detailModel.workspaceId;
                }
                var url = vm.endPoint + "resourceworkspaces/" + vm.class_name_doc + "/" + item.docFileId + "/" + workspaceVal;
                axios.delete(url, {
                    headers: vm.headers
                  }).then(function(response) {
                    vm.khoDuLieuListItems.splice(index, 1);
                    vm.snackbartextkhoTuLieuViewJX = "Xoá dữ liệu thành công!";
                    vm.snackbarkhoTuLieuViewJX = true;
                    vm.loadingkhoTuLieuViewJX = false;
                  })
                  .catch(function(error) {
                    console.log(error);
                    vm.snackbartextkhoTuLieuViewJX = "Xoá dữ liệu thất bại!";
                    vm.snackbarkhoTuLieuViewJX = true;
                    vm.loadingkhoTuLieuViewJX = false;
                  });
                dialog.close();
              })
              .catch(function(e) {
                console.log(e);
              })
            },
            toRemoveDocFile: function(item) {
              var vm = this;
              vm.$dialog.confirm('Bạn có muốn xóa văn bản này?', {
                html: true,
                loader: true,
                okText: 'Xác nhận',
                cancelText: 'Quay lại',
                animation: 'fade'
              })
              .then(function(dialog) {
                var url = vm.endPoint + "docfiles/" + item.docFileId;
                axios.delete(url, {
                    headers: vm.headers
                  }).then(function(response) {
                    vm._inikhoDuLieuList(null);
                    vm.backToList();
                    vm.snackbartextkhoTuLieuViewJX = "Xoá dữ liệu thành công!";
                    vm.snackbarkhoTuLieuViewJX = true;
                    vm.loadingkhoTuLieuViewJX = false;
                  })
                  .catch(function(error) {
                    console.log(error);
                    vm.snackbartextkhoTuLieuViewJX = "Xoá dữ liệu thất bại!";
                    vm.snackbarerorkhoTuLieuViewJX = true;
                    vm.loadingkhoTuLieuViewJX = false;
                  });
                dialog.close();
              })
              .catch(function(e) {
                console.log(e);
              })
            },
			      setWorkspaceTree: function(item) {
              var vm = this;
              var newTree = vm.workspaceTree.filter(function(workspace) {
                return (item.treeIndex.indexOf(workspace.treeIndex) >= 0 && item.treeIndex !== workspace.treeIndex);
              });
              newTree.push(item);
              vm.workspaceTree = newTree;
            },
            previewAttachPDFTab: function(item) {
              
              var vm = this;
              vm.no_list_access = false;
              if (item.workspaceId) {
                console.log(item);
                vm.setWorkspaceTree(item);
                vm.detailModel = vm.workspaceTree.slice(-1)[0];
                vm._inikhoDuLieuList(null);
              } else {
                var url = vm.endPoint + "fileattachs/" + item.docFileId;
                axios.get(url, config_blob).then(function(response) {
                  // var url = window.URL.createObjectURL(response.data);
                  // window.open(url);
                  var fileName = response.headers['content-disposition'];
                  fileName = fileName.split('"')[1];
                  var a = document.createElement("a");
                  document.body.appendChild(a);
                  a.style = "display: none";
                  var url = window.URL.createObjectURL(response.data)
                  a.href = url;
                  a.download = fileName;
                  a.click();
                  window.URL.revokeObjectURL(url);
                })
                .catch(function(error) {
                  console.log(error);
                });
              }
            },
            toDetailDocFile: function(id) {
              var vm = this;
              if (id > 0) {
                vm.options.target = '/o/v2/mobilink/fileattachs/upload/'+vm.class_name_doc+'/'+id+'/'+vm.groupId;
                vm.class_pk = id;
                vm.currentListPage = false;
                window.history.pushState('', '', themeDisplay.getLayoutURL() + '/-/docfile/' + id);	
                var url = vm.endPoint + "docfiles/" + id;
                axios.get(url, config).then(function(response) {
                  vm.docFileDetail = response.data;
                  //vm.docFileDetail['permission']='write';
                  setTimeout(
                  function() {
                    vm._initThuMucLuuTruWorkspaces(vm.class_name_doc, vm.class_pk);
                    if (vm.secutypeItems.length <= 0) {
                      vm._initSecutype();
                    }
                    if (vm.priorityItems.length <= 0) {
                      vm._initPriority();
                    }
                    if (vm.registerItems.length <= 0) {
                      vm._initRegister();
                    }
                    if (vm.issuerCodeItems.length <= 0) {
                      vm._initIssuerCode();
                    }
                    if (vm.documentCatItems.length <= 0) {
                      vm._initDocumentCat();
                    }
                    if (vm.templateNoItems.length <= 0) {
                      vm._initTemplateNo();
                    }
                    
                    vm.initEditableControl(
                      [
                        {
                          name: 'content',
                          value: 'content'
                        },
                        {
                          name: 'priority',
                          value: 'priority'
                        },
                        {
                          name: 'secutype',
                          value: 'secutype'
                        },
                        {
                          name: 'documentCat',
                          value: 'documentCat'
                        },
                        {
                          name: 'language',
                          value: 'language'
                        },
                        {
                          name: 'promulgationAmount',
                          value: 'promulgationAmount'
                        },
                        {
                          name: 'pageAmount',
                          value: 'pageAmount'
                        },
                        {
                          name: 'signerInfo',
                          value: 'signerInfo'
                        },
                        {
                          name: 'promulgationDate',
                          value: 'promulgationDate',
                          type: 'date'
                        },
                        {
                          name: 'registerDate',
                          value: 'registerDate',
                          type: 'date'
                        },
                        {
                          name: 'register',
                          value: 'register'
                        },
                        {
                          name: 'issuerCode',
                          value: 'issuerCode'
                        },
                        {
                          name: 'templateNo',
                          value: 'templateNo'
                        }
                      ],
                      vm.docFileDetail,
                      vm.class_pk,
                      'owner,leader,hoster,manager'.indexOf( vm.docFileDetail['permission'] ||'none' )>=0?true:false,
                      vm
                    );
                    vm.thuMucLuuTruWorkspacespk = vm.class_pk;
                    vm.thuMucLuuTruWorkspacespermission = vm.docFileDetail['permission'];
                  },500);
                })
                .catch(function(error) {
                  console.log(error);
                });
              }
            },
            backToList: function() {
              this.currentListPage = true;
              this.detailShowMore = false;
              window.history.pushState('', '', themeDisplay.getLayoutURL());
            }
          }
        },
        /** popup */
        'popUpEditDocFile': {
          'id': 'popUpEditDocFile',
          'name': 'popUpEditDocFile',
          "type": "dialogsm",
          "type_dialog": "fullScreen",
          'icon_save': 'undo',
          'label_save': 'Quay lại',
          "color": "primary",
          "template": "popUpEditDocFileTemplate",
          "events": {
            successCallBack: function (id) {
            	this.popUpEditDocFile = false;
            	this.popUpEditDocFileTemp = false;
            	this.toDetailDocFile(id);
            },
            popUpEditDocFileClose: function() {
              this.popUpEditDocFile = false;
            },
            popUpEditDocFileSave: function() {
              var vm = this;
              vm.popUpEditDocFile_hidden_loading = true;
              vm.$refs['uploadcom1'].createDocFileSubmit();
              vm.popUpEditDocFile_hidden_loading = false;
            }
          }
        },
        'popUpEditDocFileTemp': {
          'id': 'popUpEditDocFileTemp',
          'name': 'popUpEditDocFileTemp',
          "type": "dialogsm",
          "type_dialog": "fullScreen",
          'icon_save': 'undo',
          'label_save': 'Quay lại',
          "color": "primary",
          "template": "popUpEditDocFileTempTemplate",
          "events": {
          	popUpEditDocFileTempClose: function() {
              this.popUpEditDocFileTemp = false;
            },
            popUpEditDocFileTempSave: function() {
              var vm = this;
              vm.popUpEditDocFileTemp_hidden_loading = true;
              vm.$refs['uploadcom2'].createDocFileSubmit();
              vm.popUpEditDocFileTemp_hidden_loading = false;
            }
          }
        },
        'popUpEditWorkspace': {
          'id': 'popUpEditWorkspace',
          'name': 'popUpEditWorkspace',
          "type": "dialogsm",
          "type_dialog": "fullScreen",
          'icon_save': 'undo',
          'label_save': 'Quay lại',
          "color": "primary",
          "template": "popUpEditWorkspaceTemplate",
          "events": {
            popUpEditWorkspaceClose: function() {
              this.popUpEditWorkspace = false;
            },
            popUpEditWorkspaceSave: function() {
              var vm = this;
              vm.popUpEditWorkspace_hidden_loading = true;
              setTimeout(
                function() {
                  vm.popUpEditWorkspace_hidden_loading = false;
                },
                500);
              /** TODO: Save form*/
              var url = vm.endPoint + "workspaces";
              var parentWorkspaceId = 0;
              console.log(vm.parentWorkspace);
              if (vm.parentWorkspace instanceof Object) {
              	parentWorkspaceId = vm.parentWorkspace.workspaceId;
              } else {
              	parentWorkspaceId = vm.parentWorkspace;
              }
              var postData = new URLSearchParams();
              postData.append('name', vm.workspaceName);
              postData.append('sibling', vm.workspaceSibling);
              postData.append('seqOrder', vm.workspaceSibling);
              postData.append('parentId', parentWorkspaceId);
              if (vm.workspaceId > 0) {
                url = url + '/' + vm.workspaceId;
                axios.put(url, postData, config).then(function(response) {
                    var serializable = vm._mapModelDetail(response.data, false);
                    if (vm.detailModel.workspaceId == serializable.parentId) {
                      vm.khoDuLieuListItems.splice(vm.currentIndex, 1, serializable);
                    }
                    vm.detailModel.name = serializable.name;
                    vm.apistate1 = 1;
                    vm.popUpEditWorkspace = false;
                    setTimeout(
                      function() {
                        vm.apistate1 = 0;
                      },
                      3000);
                      //update shared
                      vm.detailModel.workspaceId = serializable.workspaceId;
		              var paramsApiUser = new URLSearchParams();
		              paramsApiUser.append('users', JSON.stringify(vm.workspaceUser));
		              paramsApiUser.append('className', vm.class_name);
		              paramsApiUser.append('classPK', vm.detailModel.workspaceId);
		              axios.post('/o/v2/mobilink/resourceusers/update',
		                  paramsApiUser,
		                  config
		                )
		                .then(function(response) {
		                  vm.apistate2 = 1;
		                  setTimeout(
		                    function() {
		                      apistate2 = 0;
		                    },
		                    3000);
		                })
		                .catch(function(error) {
		                  console.log(error);
		                  vm.apistate2 = 2;
		                  setTimeout(
		                    function() {
		                      apistate2 = 0;
		                    },
		                    3000);
		                });
		              var paramsApiRole = new URLSearchParams();
		              paramsApiRole.append('roles', JSON.stringify(vm.workspaceRole));
		              paramsApiRole.append('className', vm.class_name);
		              paramsApiRole.append('classPK', vm.detailModel.workspaceId);
		              axios.post('/o/v2/mobilink/resourceroles/update',
		                  paramsApiRole,
		                  config
		                )
		                .then(function(response) {
		                  vm.apistate3 = 1;
		                  setTimeout(
		                    function() {
		                      vm.apistate3 = 0;
		                    },
		                    3000);
		                })
		                .catch(function(error) {
		                  console.log(error);
		                  vm.apistate3 = 2;
		                  setTimeout(
		                    function() {
		                      vm.apistate3 = 0;
		                    },
		                    3000);
		                })
                  })
                  .catch(function(error) {
                    console.log(error);
                    vm.apistate1 = 2;
                    setTimeout(
                      function() {
                        vm.apistate1 = 0;
                      },
                      3000);
                  });
              } else {
                axios.post(url, postData, config).then(function(response) {
                  var serializable = vm._mapModelDetail(response.data, false);
                  
                  if (vm.detailModel.workspaceId == serializable.parentId && vm.khoDuLieuListItems.length > 0) {
                    vm.khoDuLieuListItems.unshift(serializable);
                  }
                  vm.apistate1 = 1;
                  setTimeout(
                    function() {
                      vm.apistate1 = 0;
                    },
                    3000);
                    vm.popUpEditWorkspace = false;
                    vm._initworkspace0Filter();
                    //update shared
		              var paramsApiUser = new URLSearchParams();
		              paramsApiUser.append('users', JSON.stringify(vm.workspaceUser));
		              paramsApiUser.append('className', vm.class_name);
		              paramsApiUser.append('classPK', serializable.workspaceId);
		              axios.post('/o/v2/mobilink/resourceusers/update',
                    paramsApiUser,
                    config
                  )
                  .then(function(response) {
                    vm.apistate2 = 1;
                    setTimeout(
                      function() {
                        apistate2 = 0;
                      },
                    3000);
                  })
                  .catch(function(error) {
                    console.log(error);
                    vm.apistate2 = 2;
                    setTimeout(
                      function() {
                        apistate2 = 0;
                      },
                    3000);
                  });
		              var paramsApiRole = new URLSearchParams();
		              paramsApiRole.append('roles', JSON.stringify(vm.workspaceRole));
		              paramsApiRole.append('className', vm.class_name);
		              paramsApiRole.append('classPK', serializable.workspaceId);
		              axios.post('/o/v2/mobilink/resourceroles/update',
                    paramsApiRole,
                    config
                  )
                  .then(function(response) {
                    vm.apistate3 = 1;
                    setTimeout(
                      function() {
                        vm.apistate3 = 0;
                      },
                      3000);
                  })
                  .catch(function(error) {
                    console.log(error);
                    vm.apistate3 = 2;
                    setTimeout(
                      function() {
                        vm.apistate3 = 0;
                      },
                    3000);
                  })
                })
                .catch(function(error) {
                  console.log(error);
                  vm.apistate1 = 2;
                  setTimeout(
                    function() {
                      vm.apistate1 = 0;
                    },
                  3000);
                });
              }
              
            }
          }
        },
        'templateNo': {
          'id': 'templateNo',
          'name': 'templateNo',
          'type': 'select',
          'label': 'Sổ theo dõi: ',
          'mode': 'editable',
          'labelClass': ' xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          "item_text": "subject",
          "item_value": "templateNo",
          "hide_selected": true,
          "loading": false,
          "items": [],
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            _initTemplateNo: function() {
              var vm = this;
              axios.get('/o/v2/mobilink/docfiles?template=1&sort=subject', config)
              .then(function (response) {
                var serializable = response.data
                if (serializable.hasOwnProperty('data')) {
                  for (var key in serializable.data) {
                      vm.templateNoItems.push(serializable.data[key])
                  }
                } else {
                  vm.templateNoItems = []
                }
              })
              .catch(function (error) {
                console.log(error)
              })
            },
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'thuMucLuuTruWorkspaces': {
          'id': 'thuMucLuuTruWorkspaces',
          'name': 'thuMucLuuTruWorkspaces',
          'type': 'select',
          'label': 'Thư mục lưu trữ: ',
          'mode': 'editable',
          'chips': true,
          'deletable_chips': true,
          'multiple': true,
          'labelClass': ' xs12 sm2',
          'controlClass': 'xs12 sm10',
          'updateapi': '/o/v2/mobilink/docfiles',
          "item_text_adv": "workspaceNamePath",
          "item_text": "workspaceNamePath",
          "item_value": "workspaceId",
          "hide_selected": true,
          "loading": false,
          "items": [],
          'updateapi': '/o/v2/mobilink/resourceworkspaces/update',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'myErrornackbarCall',
          'events': {
            _initThuMucLuuTruWorkspaces: function(className, classPK) {
              var vm = this;
              vm.class_name = className;
              vm.class_pk = classPK;
              axios.get('/o/v2/mobilink/resourceworkspaces/'+className+'/'+classPK+'?sort=workspaceName&full=true&permanent=true', config)
              .then(function (response) {
                var serializable = response.data
                vm.thuMucLuuTruWorkspacesItems = serializable.data;
                vm.thuMucLuuTruWorkspaces = [];
                for (var key in vm.thuMucLuuTruWorkspacesItems) {
                  vm.thuMucLuuTruWorkspacesItems[key]['permanent']=true;
                  if (vm.thuMucLuuTruWorkspacesItems[key].hasOwnProperty('selected') && vm.thuMucLuuTruWorkspacesItems[key]['selected'] === true ) {
                    vm.thuMucLuuTruWorkspaces.push(vm.thuMucLuuTruWorkspacesItems[key]);
                  }
                }
                vm.docFileDetail['thuMucLuuTruWorkspaces'] = vm.thuMucLuuTruWorkspaces
                vm.initEditableControl(
                      [
                        {
                          name: 'thuMucLuuTruWorkspaces',
                          value: 'thuMucLuuTruWorkspaces'
                        }
                      ],
                      vm.docFileDetail,
                      vm.class_pk,
                      'owner,leader,hoster,manager'.indexOf( vm.docFileDetail['permission'] ||'none' )>=0?true:false,
                      vm
                    );
              })
              .catch(function (error) {
                console.log(error)
              })

            },
            mySuccesssnackbarCall: function(value) {
              var vm = this
              vm.snackbarkhoTuLieuViewJX = false;
              console.log(vm.thuMucLuuTruWorkspaces);
              console.log('tess');
            },
            myErrornackbarCall: function(value) {
              var vm = this
              vm.snackbarerorkhoTuLieuViewJX = false;
              
              var paramsApi2 = new URLSearchParams()
              paramsApi2.append('workspaces', JSON.stringify(vm.thuMucLuuTruWorkspaces))
              paramsApi2.append('className', vm.class_name)
              paramsApi2.append('classPK', vm.class_pk)
              
              axios.post('/o/v2/mobilink/resourceworkspaces/update',
                paramsApi2,
                config
              )
              .then(function (response) {
                vm.thuMucLuuTruWorkspaces_hidden_loading = false;
                vm.thuMucLuuTruWorkspaces_hidden = true;
                vm.snackbartextkhoTuLieuViewJX = "Cập nhật dữ liệu thành công!";
                  vm.snackbarkhoTuLieuViewJX = true
                  
              })
              .catch(function (error) {
                console.log(error)
                vm.thuMucLuuTruWorkspaces_hidden_loading = false;
                vm.snackbartextkhoTuLieuViewJX = "Cập nhật dữ liệu thất bại!";
                  vm.snackbarerorkhoTuLieuViewJX = true;
              })
            }
          }
        },
        'register': {
          'id': 'register',
          'name': 'register',
          'type': 'select',
          'label': 'Loại sổ: ',
          'mode': 'editable',
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          "item_text": "text",
          "item_value": "value",
          "hide_selected": true,
          "loading": false,
          "items": [],
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            _initRegister: function() {
              this.registerItems = [{
                  'value': 0,
                  'text': 'Khác'
                },
                {
                  'value': 2,
                  'text': 'Đến'
                },
                {
                  'value': 1,
                  'text': 'Đi'
                }
              ];
            },
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'registerDate': {
          'id': 'registerDate',
          'name': 'registerDate',
          'type': 'date',
          'label': 'Ngày đến/phát hành: ',
          'placeholder': 'Nhập dữ liệu',
          'mode': 'editable',
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'promulgationDate': {
          'id': 'promulgationDate',
          'name': 'promulgationDate',
          'type': 'date',
          'label': 'Ngày ban hành: ',
          'placeholder': 'Nhập dữ liệu',
          'mode': 'editable',
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'issuerCode': {
          'id': 'issuerCode',
          'name': 'issuerCode',
          'type': 'select',
          'label': 'Cơ quan ban hành: ',
          'no_data_text': 'Chưa có',
          'mode': 'editable',
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          "item_text": "itemName",
          "item_value": "itemCode",
          "hide_selected": true,
          "loading": false,
          "items": [],
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            _initIssuerCode: function() {
              var vm = this;
              var url = vm.endPoint + "dictcollections/GOVERMENT_AGENCY/dictitems";
              axios.get(url, config).then(function(response) {
                  var serializable = response.data;
                  if (serializable.hasOwnProperty('data')) {
                    vm.issuerCodeItems = serializable.data;
                  }
                })
                .catch(function(error) {
                  console.log(error);
                });
            },
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'signerInfo': {
          'id': 'signerInfo',
          'name': 'signerInfo',
          'type': 'text',
          'label': 'Người ký: ',
          'placeholder': 'cập nhật tên người ký ...',
          'mode': 'editable',
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'documentCat': {
          'id': 'documentCat',
          'name': 'documentCat',
          'type': 'select',
          'label': 'Loại/Kiểu văn bản: ',
          'no_data_text': 'Chưa có',
          'mode': 'editable',
          'chips': true,
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          "item_text_adv": "texttemp",
          "item_text": "text",
          "item_value": "value",
          "hide_selected": true,
          "loading": false,
          "items": [],
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            _initDocumentCat: function() {
              var vm = this;
              vm.documentCatItems = [];
              var url = vm.endPoint + "dictcollections/DOCUMENT_TYPE/dictitems?sort=treeIndex";
              var parentName = '';
              axios.get(url, config).then(function(response) {
                var serializable = response.data;
                if (serializable.hasOwnProperty('data')) {
                  for (var key in serializable.data) {
                    if (serializable.data[key].level === 0) {
                      parentName = serializable.data[key].itemName;
                      vm.documentCatItems.push({
                        header: serializable.data[key].itemName
                      });
                    } else {
                      vm.documentCatItems.push({
                        text: serializable.data[key].itemName,
                        texttemp: parentName + ' / ' +serializable.data[key].itemName,
                        value: serializable.data[key].itemCode
                      });
                    };
                  };
                };
              })
              .catch(function(error) {
                console.log(error);
              });
            },
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'language': {
          'id': 'language',
          'name': 'language',
          'type': 'text',
          'label': 'Ngôn ngữ: ',
          'placeholder': 'Nhập dữ liệu',
          'mode': 'editable',
          'labelClass': ' xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'promulgationAmount': {
          'id': 'promulgationAmount',
          'name': 'promulgationAmount',
          'type': 'number',
          'label': 'Số bản: ',
          'placeholder': 'nhập số bản',
          'mode': 'editable',
          'labelClass': ' xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường số bản thành công!',
          'error_msg': 'Số bản bắt buộc nhập số!',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'pageAmount': {
          'id': 'pageAmount',
          'name': 'pageAmount',
          'type': 'number',
          'label': 'Số trang: ',
          'placeholder': 'nhập số trang ...',
          'mode': 'editable',
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường số trang thành công!',
          'error_msg': 'Số trang bắt buộc nhập số!',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'priority': {
          'id': 'priority',
          'name': 'priority',
          'type': 'select',
          'label': 'Độ khẩn: ',
          'mode': 'editable',
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          "item_text": "text",
          "item_value": "value",
          "hide_selected": true,
          "loading": false,
          "items": [],
          'labelClass': ' xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            _initPriority: function() {
              var vm = this;
              vm.priorityItems = [{
                  'value': 0,
                  'text': 'Bình thường'
                },
                {
                  'value': 1,
                  'text': 'Hỏa tốc'
                },
                {
                  'value': 2,
                  'text': 'Hỏa tốc hẹn giờ'
                },
                {
                  'value': 3,
                  'text': 'Thượng khẩn'
                }
              ];
            },
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'secutype': {
          'id': 'secutype',
          'name': 'secutype',
          'type': 'select',
          'label': 'Độ mật: ',
          'mode': 'editable',
          'labelClass': 'xs12 sm4',
          'controlClass': 'xs12 sm8',
          'updateapi': '/o/v2/mobilink/docfiles',
          "item_text": "text",
          "item_value": "value",
          "hide_selected": true,
          "loading": false,
          "items": [],
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            _initSecutype: function() {
              var vm = this;
              vm.secutypeItems = [{
                  'value': 0,
                  'text': 'Bình thường'
                },
                {
                  'value': 1,
                  'text': 'Tuyệt mật'
                },
                {
                  'value': 2,
                  'text': 'Tối mật'
                },
                {
                  'value': 3,
                  'text': 'Mật'
                }
              ];
            },
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        },
        'content': {
          'id': 'content',
          'name': 'content',
          'type': 'text',
          'textarea': true,
          'label': 'Tóm tắt nội dung: ',
          'placeholder': 'nhập tóm tắt nội dung ...',
          'mode': 'editable',
          'labelClass': 'xs12 sm2',
          'controlClass': 'xs12 sm9',
          'updateapi': '/o/v2/mobilink/docfiles',
          'success_msg': 'Cập nhật trường text này thành công',
          'error_msg': 'Cập nhật trường text này thất bại',
          'call_back_success': 'mySuccesssnackbarCall',
          'call_back_error': 'mySuccesssnackbarCall',
          'events': {
            mySuccesssnackbarCall: function(value) {
              console.log(value);
            }
          }
        }
      }
    });

    khoTuLieuViewJX._builder('khoTuLieuViewJX');

  });

</script>

<style>
  .nav_drawn_width_none aside {
    width: 0px !important;
  }
  
  #khoTuLieuViewJX span.tooltip{
    font-size: 14px!important;
    font-family: 'Roboto',sans-serif!important;
  }
  #khoTuLieuViewJX .row-header {
    background-color: #3486D7!important;
    color: #ffffff!important;
    overflow: hidden;
    width: 100%;
  }
  #khoTuLieuViewJX .row-header button{
    background-color: #01579b!important;
    color: white!important;
    text-transform: none;
    height: 30px!important;
    min-width: 150px;
  }
  #khoTuLieuViewJX .row-header .input-group .input-group__input{
    background-color: #ffffff!important;
    padding-left: 3px!important;
    border-radius: 2px!important;
    color: #3486D7 !important;
  }
  #khoTuLieuViewJX a.breadcrumbs__item{
    color: #ffffff!important
  }
  #khoTuLieuViewJX .danhSachPaymentTable__class table tr td{
    overflow: hidden;
    text-overflow: ellipsis; 
    white-space: nowrap;
    border: 1px solid #ddd !important;
  }
  #khoTuLieuViewJX .danhSachPaymentTable__class table thead tr th{
    border: 1px solid #ddd !important;
    color: #000!important
  }
  .max-width {
    width: 100% !important;
    max-width: 100% !important;
  }

  .no-width {
    width: 0px !important;
    max-width: 0px !important;
  }

  .max-width146 .labelClass {
    max-width: 146px;
  }

  .detail_show_more {
    margin: 0;
  }

  .detail_show_more .btn__content {
    padding: 0;
    text-transform: none;
    color: #939393;
  }

  body .danhSachPaymentTable__class table.table th:nth-child(1) {
    width: 20%;
    background-color: transparent!important;
  }

  body .danhSachPaymentTable__class table.table th:nth-child(2) {
    width: 12%;
  }

  body .danhSachPaymentTable__class table.table th:nth-child(3) {
    width: 59%;
  }
  body .danhSachPaymentTable__class table.table th:nth-child(4) {
    width: 9%;
  }

  .btn__nopadding {
    padding: 0px;
  }

  .nav__btn__custom .btn__content {
    justify-content: left;
    padding: 0;
    align-items: flex-end;
    text-transform: none;
  }

  .nav__btn__custom .btn__content .material-icons {
    padding-right: 5px;
  }
  
  .mobilink-shared-root.editable-wrap.editable-wrap-before-select .input-group--chips label{
    display: block;
	}
	.mobilink-shared-root.editable-wrap.editable-wrap-before-select .input-group {
	  padding-top: 20px;
	}
	.codeNo__codeNotation .input-group{
		padding-top: 0px;
	}
  .expMenu .expansion-panel{
    border: 0px;
  }
  .expMenu>li{
    width: 100%!important
  }
  .expMenu .expansion-panel__header{
    font-family: 'Roboto'!important;
    color:rgba(0,0,0,0.87)!important;
    border: 0px;
    background-color: #EFEFEF;
    padding: 0px
  }
  .expMenu .expansion-panel__header .nav__btn__custom{
    font-weight: 500;
    font-size: 13px;
    color:rgba(0,0,0,0.87)!important;
  }
  .expansion-panel__header .icon {
      color: rgba(0,0,0,0.54)!important;
  }
  .expMenu .expansion-panel__header:hover{
    background-color: #C6C6C6
  }
  #danhSachPaymentTable__class table{
    table-layout: fixed
  }
  table{
    table-layout: fixed
  }
  .headerDetail{
        background: #e1f5fe;
    }
    .controlClass .input-group__selections__comma{
        font-size: 14px;
    }
    .controlClass .chip__content{
        font-size:14px
    }
    body table.table td a:hover{
        color: #1a5eba!important;
    }
</style>

