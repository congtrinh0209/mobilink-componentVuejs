
<!-- TODO Template Xây dựng navigation -->
<input type="hidden" >
<div id="menu_template" class="hidden">
	<div class="layout row wrap">
		
		<div class="flex xs12">
			<v-btn v-on:click.native="openPopUpAddNewsBoard" block color="primary" class="btn--menu-add my-0">
				Thêm mới bản tin
			</v-btn>
		</div>

		<div class="flex xs12 pl-3" jx-bind="newsBoardFilter"></div>
		
		<div class="flex xs12 pl-3" jx-bind="workspaceFilter"></div>

		<div class="flex sm6 xs12 pl-3" jx-bind="monthFilter"></div>

		<div class="flex sm6 xs12 pl-3" jx-bind="yearFilter"></div>

	</div>
</div>

<!-- TODO newsBoardViewJX template one page -->
<div id="newsBoardViewJX_form_template" class="hidden">
	<div class="jx-content-wrap">
		
		<div class="row-header flex-break" v-if="!keywordsSearchable" >
			<div style="padding: 10px 5px 10px 15px; width: auto; font-family: 'Roboto-Bold';"> {{newsBoardFilterItemSelect.title}} </div> 
			<v-icon>forward</v-icon>
			<div class="flex w-100-xs pl-2">Có {{newsBoardListItems.length}} kết quả.</div>
			<v-btn icon v-on:click.native="keywordsSearchable = !keywordsSearchable" class="my-0">
				<v-icon>search</v-icon>
			</v-btn>
		</div>
		
		<v-slide-y-transition>
			<div class="row-header flex-break my-0" v-if="keywordsSearchable" >
				
				<v-toolbar scroll-off-screen class="my-0 row-header">
					<v-btn icon v-on:click.native="keywordsSearchable = !keywordsSearchable" class="my-0">
						<v-icon>arrow_back</v-icon>
					</v-btn>
					<div v-if="keywordsSearchable" class="flex pr-3 w-100-xs" jx-bind="keywordsSearch" 
						style="display: flex;display: -webkit-flex;">
					</div>

				</v-toolbar>
					
			</div>
		</v-slide-y-transition>
		
		<v-slide-x-transition>
			<v-expansion-panel expand>
				<v-expansion-panel-content v-for="(item, index) in newsBoardListItems" :key="index" v-bind:value="true">
					
					<v-card :class="item.newsBoardId !== showCurrentId ? overHidden : ''">
						<div class="layout wrap">
							<div class="flex sm4 xs12 pt-2">
								<v-card-media >
        						
	        						<jx-mobilink-album-image-use
								        :id="item.newsBoardId"
								        :class_name="className"
									    :class_pk="item.newsBoardId"
									    :group_id="groupId"
									    @init-album-file-upload="initAlbumFileUpload"
										:options="optionsAlbum"
										album_api="/o/v2/mobilink/albumfiles"
									></jx-mobilink-album-image-use>

        						</v-card-media>
								
								<v-slide-y-transition>
									<div class="flex xs12">
										<v-card-text v-if="item.newsBoardId === showCurrentId" class="px-0">
											<uploader :options="options" class="uploader-example">
												<uploader-unsupport></uploader-unsupport>
												<uploader-list 
													:id="item.newsBoardId"
													developer-key='AIzaSyAouTfMdrvMHjAwvF9RVsvwsuN1WSzGjmM'
													client-id='790244148120-0grj2n5evkij0kqqthkbtgb18i0gup1j.apps.googleusercontent.com'
													view-id='DOCS'
													:class_name="className"
													:class_pk="item.newsBoardId"
													:group_id="groupId"
													file_attach_api="/o/v2/mobilink/fileattachs"
													extensions_upload="true"
													:permission="item.permission"
												></uploader-list>
											</uploader>
											<v-card-text class="px-0">
												<jx-mobilink-share 
													visibilities_api="/o/v2/mobilink/visibilities"
													resourceworkspace_get_api="/o/v2/mobilink/resourceworkspaces"
													resourceroles_get_api="/o/v2/mobilink/resourceroles"
													resourceusers_get_api="/o/v2/mobilink/resourceusers"
													changelogs_get_api="/o/v2/mobilink/changelogs"
													:class_name="className"
													:class_pk="item.newsBoardId"
													:group_id="groupId"
													:permission="item.permission"
												></jx-mobilink-share>
											</v-card-text>
											
											<div class="ml-3 mb-3">Loại bản tin : <b>{{ item.categoryName}}</b></div>
											<div class="ml-3 mb-3">Kiểu bản tin : <b>{{ item.newsType}}</b></div>

											<v-btn outline color="blue-grey" class="mx-0 my-0 px-0 py-0 ml-3 mb-2" v-on:click.native="editNewsboard(item, index)">
												<v-icon>edit</v-icon>  Sửa bản tin
											</v-btn>
											<v-btn outline color="blue-grey" class="mx-0 my-0 px-0 py-0 ml-3 mb-2" v-on:click.native="deleteNewFeed(item, index)">
												<v-icon>delete</v-icon>  Xóa bản tin
											</v-btn>
											
										</v-card-text>
									</div>
								</v-slide-y-transition>
							</div>
	
							<div class="flex sm8 xs12 content__boder__left pt-2">
								<p class="ml-3 mb-2">
									<v-icon>alarm_on</v-icon>
									<span title="Ngày đăng tải">{{ item.publicationDate | date }}</span> - <span title="Ngày hết hạn">{{ item.expireDate | date }}</span>
								</p>
								<v-card-text class="py-0">
									<div style="font-size: 16px" class="mb-3"><b>{{ item.title }}</b></div>
									<div v-html="item.content" :id="item.newsBoardId" v-if="item.newsBoardId === showCurrentId"></div>

									<div class="mt-3 title-comment" v-if="item.newsBoardId === showCurrentId">

										<jx-mobilink-comment
											id="item.newsBoardId"
											@init-comment="initComment"
											:class_name="className"
											:class_pk="item.newsBoardId"
											:group_id="groupId"
											comments_api="/o/v2/mobilink/comments"
											expanded="true"
											:user_id="current_user_id"
											:full_name="current_user_name"
										  ></jx-mobilink-comment>
									</div>

									<div color="blue-grey" v-if="item.newsBoardId !== showCurrentId" class="btn-showmore mx-0 my-0 px-0 py-0" v-on:click="viewMoreFunc(item)" >
									Xem thêm >>
									</div>

									<div color="blue-grey" class="btn-showless mx-0 my-0 px-0 py-0" v-on:click="showCurrentId = 0" v-else>
										<< Rút gọn
									</div>
					
								</v-card-text>
							</div>
							<!-- <div class="flex xs12" v-if="item.newsBoardId === showCurrentId">
								<hr class="content__boder__bottom mt-0 mb-0"></hr>
							</div> -->
							
							
						</div>
					</v-card>
					
				</v-expansion-panel-content>
			</v-expansion-panel>
		</v-slide-x-transition>
		
	</div>
</div>

<div id="popUpAddNewsBoardTemplate">
	<div class="flex xs12" style="margin-top: 30px;">
		<v-form v-model="valid" ref="form" lazy-validation>
			<div class="layout wrap">
				
				<v-flex xs12 sm2 class="mt-3">
					<v-subheader class="px-0">Loại bản tin</v-subheader>
				</v-flex>
				<v-flex xs12 sm4>
					<v-select
						v-bind:items="newsCatItems"
						v-model="newsCat"
						item-text="categoryName"
						item-value="newsCat"
						autocomplete
						return-object
						hide-selected
						:rules="[v => !!v || 'This field is required!']"
						required
					></v-select>
				</v-flex>
				<!--  -->
				
				<v-flex class="sm6 xs12 pl-4 pt-3">
					<v-checkbox v-bind:label="`Bản tin nằm ở đầu trang`" v-model="onTop"></v-checkbox>
				</v-flex>

				<!--  -->
                <v-flex xs12 sm2 class="mt-3">
                    <v-subheader class="px-0">Ngày đăng tải </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="mt-3">
                    <date-picker class="mt-2" v-model="timeStart" placeholder="Ngày đăng tải" @confirm = "changeDateStart" v-bind:not-before="timeStartMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="en" type="date" format="dd-MM-yyyy" confirm="true"></date-picker>
                </v-flex>
				<!--  -->

                <v-flex xs12 sm2 class="pl-3 mt-3">
                    <v-subheader class="px-0 pl-2">Ngày hết hạn </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="mt-3">
                    <date-picker class="mt-2" v-model="timeEnd" placeholder="Ngày hết hạn đăng tải" v-bind:not-before="timeEndMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="en" type="date" format="dd-MM-yyyy" confirm="true"></date-picker>
                </v-flex>
				<!--  -->
				<v-flex xs12 sm2 class="mt-2">
                    <v-subheader class="px-0">Tiêu đề </v-subheader>
				</v-flex>
				<v-text-field xs12 sm10
					placeholder="Tiêu đề "
					v-model="newFeedTitle"
					multi-line
				></v-text-field>
				<v-flex xs12 sm12></v-flex>
				<!--  -->
				<v-flex xs12 sm2 class="mt-2">
                    <v-subheader class="px-0">Nội dung </v-subheader>
				</v-flex>
				<v-flex xs12 sm12 >
					<vue-editor v-model="newFeedContent">
					
					</vue-editor>
				</v-flex>
			</div>

		</v-form>
	</div>
</div>
<div id="newsBoardViewJX"></div>

<script type="text/javascript">
	document.addEventListener('DOMContentLoaded', function (event) {
		var config = {
			headers: {
				'groupId': themeDisplay.getScopeGroupId() 
			}
			
		};
		var collectionCode = 'NEWS_TYPE';
		var endPoint = '/o/v2/mobilink/';
		
		var newsBoardViewJX = new VueJX({
			el: 'newsBoardViewJX',
			pk: 1,
			onScroll: 'onScroll',
			data: {
				current_user_id: themeDisplay.getUserId(),
				current_user_name: themeDisplay.getUserName(),
				showCurrentId: 0,
				className: 'org.mobilink.docmgt.model.NewsBoard',
				groupId: themeDisplay.getScopeGroupId(),
				newFeedContent: '',
				newFeedTitle:'',
				newsBoardListItems: [],
				newsBoardFilterItemSelect: {
					"title": 'Bản tin mới'
				},
				keywordsSearchable: false,
				valid: false,
				endPoint: '/o/v2/mobilink/',
				headers: { groupId: themeDisplay.getScopeGroupId() },
				options: {
					target: '/o/v2/mobilink/fileattachs/upload/',
					chunkSize: 100*1024*1024,
					headers: {
						groupId: themeDisplay.getScopeGroupId()
					},
					testChunks: false
				},
				optionsAlbum: {
					target: '/o/v2/mobilink/albumfiles/upload/',
					testChunks: false
				},
				newsCatItems: [],
				newsCat:'',
				valid: false,
				onTop: false,

				timeStart: '',
				timeStartMin: '',
				timeEnd: '',
                timeEndMin: '',
				typeEditNewboard: 'POST',
				itemEdit:'',
				overHidden: 'overHidden'
			},
			schema: {
				/** TODO menu filter */
				'navigationFilter': {
					'id': 'navigationFilter',
					'name': 'navigationFilter',
					'type': 'navigation',
					'template': 'menu_template',
					'template_content': 'newsBoardViewJX_form_template'
				},
				'newsBoardFilter': {
					'id': 'newsBoardFilter',
					'name': 'newsBoardFilter',
					'type': 'listgroup',
					'child_items': 'items',
					'data_title': 'title',
					'data_value': 'id',
					'onLoad': '_initnewsBoardFilter',
					'onClick': 'filterChange',
					'events': {
						initAlbumFileUpload: function (prevewConfig) {
							this.optionsAlbum.target = '/o/v2/mobilink/albumfiles/upload/' + prevewConfig.className + '/' + prevewConfig.classPK +'/' + prevewConfig.groupId;
						},
						viewMoreFunc: function (item) {
							this.changeTitle();
							this.showCurrentId = item.newsBoardId;
							this.options.target = '/o/v2/mobilink/fileattachs/upload/' + this.className + '/' + item.newsBoardId +'/' + this.groupId;
						},
						initComment: function (prevewConfig) {
							$('#mobilink-comments-container').comments(prevewConfig);
						},
						onScroll(e) {
						},
						changeTitle: function(){
							setTimeout(function(){
								$(".title-comment .expansion-panel__header > div:nth-child(1)").html("Bình luận")
							},100)
						},
						filterChange: function (item) {
							var vm = this;

							if (item.parentItemCode == "" && item.id) {
								var url = endPoint + 'dictcollections/' 
									+ collectionCode + '/dictitems?parent=' + item.id;
								axios.get(url, config).then(function (response) {
									{
										let serializable = response.data;
										var temp = [];
										
										if (serializable.hasOwnProperty('data')) {

											for (let i = 0; i < serializable.data.length; i++) {
												temp.push({
													"action": "folder",
													"action_active": "folder_open",
													"id": serializable.data[i]["itemCode"],
													"title": serializable.data[i]["itemName"],
													"parentItemCode": item.id,
													"active": false,
													"index": i
												});
											};
											vm.newsBoardFilterItems[item.index]["items"] = temp;
										};
									};
								})
								.catch(function (error) {
									console.log(error);
								});
							};

							vm.newsBoardFilterItemSelect = item;
							vm.newsBoardFilterselected = item.id;
							vm._initNewFeedList();

						},
						openPopUpAddNewsBoard: function(){
							var vm = this;
							vm.typeEditNewboard = 'POST';
							vm.dueDate = "";
							vm.promulgationDate = "";
							vm.popUpAddNewsBoard = !vm.popUpAddNewsBoard;
							vm.newsBoardViewJXTitle = 'Thêm mới bản tin';
							// vm.newsType.itemCode = "";
							vm.newsCat.itemCode = "";
							vm.newsCatItems = [];
							vm.newFeedTitle = "";
							vm.newFeedContent = "";
							vm.getCurrentDate();
							vm._initNewsCatData();

						},
						_initNewFeedList: function () {

							var vm = this;
							var type, category, isNew;
							if ( !vm.newsBoardFilterItemSelect.id) {
								isNew = true;
							} else if (vm.newsBoardFilterItemSelect.parentItemCode != "") {
								type = vm.newsBoardFilterItemSelect.parentItemCode;
								category = vm.newsBoardFilterItemSelect.id;
							} else {
								type = vm.newsBoardFilterItemSelect.id;
							};
							
							var paramsBuilder = {
								keyword: vm.keywordsSearch,
								new: isNew,
								type: type,
								category: category,
								workspace: vm.workspaceFilter.workspaceId,
								month: vm.monthFilter.value,
								year: vm.yearFilter.value
							};
							const config = {
								params: paramsBuilder,
								headers: {
									'groupId': themeDisplay.getScopeGroupId()
								}
								
							};

							var url = endPoint + 'newsboards';
							axios.get(url, config).then(function (response) {
								var serializable = response.data;
								vm.newsBoardListItems = [];
								if ( serializable.hasOwnProperty('data') ) {
									vm.newsBoardListItems = serializable.data;
								}
								
							})
							.catch(function (error) {
								console.log(error);
								vm.newsBoardListItems = [];
							});

						},
						editNewsboard: function(item, index) {
							var vm = this;
							vm.itemEdit = item.newsBoardId;
							vm.typeEditNewboard = 'PUT';
							vm.popUpAddNewsBoard = true;
							vm.newsBoardViewJXTitle = 'Cập nhật bản tin';
							vm.newsCatItems = [];
							vm._initNewsCatData();
							vm.getCurrentDate();
							
							vm.newsCat = item;
							vm.newFeedTitle = item.title;
							vm.newFeedContent = item.content;
							vm.timeStart = new Date(item.publicationDate?moment(item.publicationDate).format('YYYY-MM-DD') : '');
							vm.timeEnd = new Date(item.expireDate?moment(item.expireDate).format('YYYY-MM-DD') : '');
							vm.onTop = item.ontop;
							
						},
						deleteNewFeed: function (item, index) {
							var vm = this;
							vm.$dialog.confirm('Bạn có muốn xóa bản tin '+ item.title +'?', {
								html: true,
								loader: true,
								okText: 'Xác nhận',
								cancelText: 'Quay lại',
								animation: 'fade'
							})
							.then((dialog) => {

								var url = endPoint + "newsboards/" + item.newsBoardId;
								axios.delete(url, config).then(function (response) {
									vm.newsBoardListItems.splice(index, 1);
									vm.snackbartextnewsBoardViewJX = "Xoá dữ liệu thành công!";
									vm.snackbarnewsBoardViewJX = true;
									vm.loadingnewsBoardViewJX = false;
								})
								.catch(function (error) {
									console.log(error);
									vm.loadingnewsBoardViewJX = false;
									vm.snackbartextnewsBoardViewJX = "Xoá dữ liệu thất bại!";
									vm.snackbarerornewsBoardViewJX = true;
								});
								
								dialog.close();
								return false; 
							})
							.catch((e) => {
								console.log(e)
							})
						},
						_initnewsBoardFilter: function () {
							var vm = this;
							var url = endPoint + 'dictcollections/' + collectionCode + '/dictitems?level=0';

							axios.get(url, config).then(function (response) {
								{
									let serializable = response.data;
									var temp = [{
										"action": "folder",
										"action_active": "folder_open",
										"id": 0,
										"title": 'Bản tin mới',
										"active": true,
										"parentItemCode": "",
										"index": 0
									}];
									
									if (serializable.hasOwnProperty('data')) {

										for (let i = 0; i < serializable.data.length; i++) {
											temp.push({
												"action": "folder",
												"action_active": "folder_open",
												"id": serializable.data[i]["itemCode"],
												"title": serializable.data[i]["itemName"],
												"parentItemCode": "",
												"active": false,
												"index": i+1
											});
											
										};
										
									};
									vm.newsBoardFilterItems = temp;
									vm.newsBoardFilterselected = temp[0].id;
									vm.newsBoardFilterItemSelect = temp[0];

									vm._initNewFeedList();
								};
							})
							.catch(function (error) {
								console.log(error);
								vm.newsBoardFilterItems = [];
							});

						},
						_initNewsCatData: function(){
							var vm = this;
							var paramsNewsCat = {
								sort: "treeIndex"
							};
							const configNewsCat = {
								params: paramsNewsCat,
								headers: {
									'groupId': themeDisplay.getScopeGroupId()
								}
								
							};
							//TODO: API
							var url = endPoint + 'dictcollections/' + collectionCode 
								+ '/dictitems';
							axios.get(url , configNewsCat).then(function (response) {
								var serializable = response.data;
								if (serializable.hasOwnProperty('data')) {
									for (var key in serializable.data) {
										if (serializable.data[key].level === 0) {
											vm.newsCatItems.push({
												header: serializable.data[key].itemName
											})
										} else {
											vm.newsCatItems.push({
												categoryName: serializable.data[key].itemName,
												newsCat: serializable.data[key].itemCode,
												newsType: serializable.data[key].parentItem.itemCode
											})
										}
										
									}
								}
							})
							.catch(function (error) {
								console.log(error);
							});
							return false;
						},
						getCurrentDate: function(){
							/**Get current date.time */
							var vm = this;
							vm.timeStart = new Date();
							vm.timeStartMin = new Date();
							vm.timeEndMin = new Date();
							var timeEnd = new Date();
							timeEnd.setHours(timeEnd.getHours() + 24);
							vm.timeEnd = timeEnd;
							/*console.log(vm)*/
						},
						changeDateStart: function(){
							var vm = this;
							setTimeout(function(){
								if(vm.typeEditNewboard == 'PUT'){
									
								} else {
									var timeEnd = new Date(vm.timeStart);
									timeEnd.setHours(timeEnd.getHours() + 24);
									vm.timeEnd = timeEnd;
									vm.timeEndMin = new Date(vm.timeStart)
								}
							},500)
						},
						parseDateFormat : function(fullDate){
							var date;
							if(fullDate){
								date = fullDate.getFullYear()+(fullDate.getMonth()+1).toString().padStart(2, '0')+fullDate.getDate().toString().padStart(2, '0')+fullDate.getHours().toString().padStart(2, '0')+fullDate.getMinutes().toString().padStart(2, '0');
							} else {
								date = ""
							}
							return date
						},
					}
				},
				/** TODO filter component */
				"workspaceFilter": {
					'id': 'workspaceFilter',
					'name': 'workspaceFilter',
					"type": "select",
					'label': 'Vùng làm việc ',
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
					"onLoad": "_initworkspaceFilterData",
					"onChange": "filterTableDocCat($event)",
					"onRemove": "filterTableDocCatOnRemove",
					'onClick': 'filterTableDocCatOnClear',
					"events": {
						_initworkspaceFilterData: function(){
							var vm = this;
							
							var url = endPoint + 'workspaces';
							axios.get(url, config).then(function (response) {
								var serializable = response.data;
								vm.workspaceFilterItems = serializable.data;
							})
							.catch(function (error) {
								console.log(error);
							});
							return false; 
						},
						filterTableDocCat: function(data){
							var vm = this;
							vm.workspaceFilter = data;
							vm._initNewFeedList();
						},
						filterTableDocCatOnRemove: function(){
							var vm = this;
							vm.workspaceFilter = [];
							vm._initNewFeedList();
						},
						filterTableDocCatOnClear: function(){
							this.workspaceFilter = [];
						}

					}
				},
				"monthFilter": {
					'id': 'monthFilter',
					'name': 'monthFilter',
					"type": "select",
					'label': 'Tháng ',
					"item_text": "text",
					"item_value": "value",
					"single_line": true,
					"hide_selected": true,
					"multiple": false,
					"tags": false, //custom input not avaliable in select
					"chips": true,
					"loading": false,
					"no_data_text": "Lua chon selected",
					"items": [],
					"onLoad": "_initmonthFilterData",
					'onChange': 'filterTableMonth($event)',
					"onRemove": "filterTableMonthOnRemove",
					'onClick': 'filterTableMonthOnClear',
					"events": {
						_initmonthFilterData: function(){
							var vm = this;
							
							var temp = [];
							for (var i =1; i<=12; i++) {
								temp.push({value: i, text: i.toString().padStart(2, "0") });
							};
							vm.monthFilterItems.push.apply( vm.monthFilterItems, temp);
							return false; 
						},
						filterTableMonth: function (data) {
							var vm = this;
							vm.monthFilter = data;
							vm._initNewFeedList();

						},
						filterTableMonthOnRemove: function(){
							var vm = this;
							
							vm.monthFilter = [];
							vm._initNewFeedList();
						},
						filterTableMonthOnClear: function(){
							this.monthFilter = [];
						}
					}
				},
				"yearFilter": {
					'id': 'yearFilter',
					'name': 'yearFilter',
					"type": "select",
					'label': 'Năm ',
					"item_text": "text",
					"item_value": "value",
					"single_line": true,
					"hide_selected": true,
					"multiple": false,
					"tags": false, //custom input not avaliable in select
					"chips": true,
					"loading": false,
					"no_data_text": "Lua chon selected",
					"items": [],
					"onLoad": "_inityearFilterData",
					'onChange': 'filterTableYear($event)',
					"onRemove": "filterTableYearOnRemove",
					'onClick': 'filterTableYearOnClear',
					"events": {
						_inityearFilterData: function(){
							var vm = this;
							
							var temp = [];
							var y = new Date().getFullYear();
							for (var i =y-5; i<=y+5; i++) {
								temp.push({value: i, text: i });
							};
							vm.yearFilterItems.push.apply( vm.yearFilterItems, temp);
							return false; 
						},
						filterTableYear: function (data) {
							var vm = this;
							vm.yearFilter = data;
							vm._initNewFeedList();

						},
						filterTableYearOnRemove: function(){
							var vm = this;
							
							vm.yearFilter = [];
							vm._initNewFeedList();
						},
						filterTableYearOnClear: function(){
							this.yearFilter = [];
						}
					}
				},
				'keywordsSearch': {
					'id': 'keywordsSearch',
					'name': 'keywordsSearch',
					'type': 'text',
					'placeholder': 'Tìm kiếm theo từ khoá...',
					'solo': true,
					'append_icon': 'search',
					'onKeyup': 'filterTableKeywords',
					'events': {
						filterTableKeywords: function (event) {
							var vm = this;
							if (event.keyCode === 13 || vm.keywordsSearch.length > 3 || vm.keywordsSearch.length === 0) {
								vm._initNewFeedList();
							}

						}
					}
				},
				/** popup */
				'popUpAddNewsBoard' : {
					'id': 'popUpAddNewsBoard',
					'name': 'popUpAddNewsBoard',
					"type": "dialogsm",
					"type_dialog": "fullScreen",
					'icon_save': 'undo',
					'label_save': 'Quay lại',
					"color": "primary",
					"template": "popUpAddNewsBoardTemplate",
					"events": {
						popUpAddNewsBoardClose: function () {
							console.log("close popup");
							/** TODO: Clear form*/
							
							this.popUpAddNewsBoard = false;
						},
						popUpAddNewsBoardSave: function () {
							if (this.$refs.form.validate()) {
								var vm = this;

								vm.popUpAddNewsBoard_hidden_loading = true;
								/** TODO: Save form*/
								var url = endPoint + "newsboards";
								
								var postData = new URLSearchParams();
								postData.append('newsType', vm.newsCat.newsType);
								postData.append('newsCat', vm.newsCat.newsCat);
								postData.append('title', vm.newFeedTitle);
								postData.append('content', vm.newFeedContent);
								postData.append('publicationDate', vm.parseDateFormat(vm.timeStart)) ;
								postData.append('expireDate', vm.parseDateFormat(vm.timeEnd)) ;
								postData.append('ontop', vm.onTop);
								if(vm.typeEditNewboard == "POST"){
									
									axios.post(url, postData, config).then(function (response) {
										setTimeout(
											function(){ 
												vm.snackbartextnewsBoardViewJX = "Thêm mới thành công!";
												vm.snackbarnewsBoardViewJX = true;
												vm.popUpAddNewsBoard_hidden_loading = false;
												vm._initNewFeedList();
												vm.popUpAddNewsBoard = false;
											}, 
										1000);
										
									})
									.catch(function (error) {
										console.log(error);
										vm.snackbartextnewsBoardViewJX = "Thêm mới thất bại!";
										vm.snackbarerornewsBoardViewJX = true;
										vm.popUpAddNewsBoard_hidden_loading = false;
									});
								} else {
									var urlPut = endPoint + "newsboards/" + vm.itemEdit;
									axios.put(urlPut, postData, config).then(function (response) {
										setTimeout(
											function(){ 
												vm.snackbartextnewsBoardViewJX = "Cập nhật bản tin thành công!";
												vm.snackbarnewsBoardViewJX = true;
												vm.popUpAddNewsBoard_hidden_loading = false;
												vm._initNewFeedList();
												vm.popUpAddNewsBoard = false;
											}, 
										1000);
										
									})
									.catch(function (error) {
										console.log(error);
										vm.snackbartextnewsBoardViewJX = "Cập nhật bản tin thất bại!";
										vm.snackbarerornewsBoardViewJX = true;
										vm.popUpAddNewsBoard_hidden_loading = false;
									});
								}
							}

						}
					}
				}
			}
		});

		newsBoardViewJX._builder('newsBoardViewJX');

	});
</script>

<style scoped>
	ul.expansion-panel li {
	margin-bottom: 15px
	}

	ul.expansion-panel {
	box-shadow: none !important;
	}
	ul.expansion-panel li .expansion-panel__header {
		/* border-left: 1px solid #e1e2e1;
		border-right: 1px solid #e1e2e1; */
		border-bottom: 2px solid #dae9f4;
		padding: 10px 15px;
	}
	.expansion-panel__body .card {
		box-shadow: none !important;
			border-top: 0 !important;
	}
	body .headline {
		font-size: 18px !important;
		line-height: 20px !important;
	}
	hr.content__boder__bottom {
	border-top: 2px solid #dae9f4;
	}
	.content__boder__left {
		border-left: 1px solid #e1e2e1;
	}
	.content__boder__left .card {
		border: 0 !important;
	}
	.news__board_comment .expansion-panel__header {
	display: none;
	}
	.news__board_comment > p {
		text-decoration: underline;
	}
	.uploader-list ul li {
	margin-bottom: 0px
	}
	.uploader-list .badge__badge {
		top: 0px;
	}
	.uploader-list .uploader-drop {
		text-align: left!important
	}
	.uploader-drop{
		padding-left: 24px!important
	}
	.uploader-drop > p {
		margin: 0;
		position: relative!important;
		top: 0!important;
		margin-top: 16px;
    	padding-left: 15px;
	}
	.expansion-panel__body .card.no-shadow {
		border-top: 1px solid #e1e2e1 !important;
	}
	.history_btn, .shared_btn {
		-webkit-box-shadow: none !important;
		box-shadow: none!important;
		border-top: 1px solid #e1e2e1;
		background-color: white !important;
		border-color: #e1e2e1 !important;
		border-left: 1px solid #e1e2e1;
		border-bottom: 1px solid #e1e2e1;
		border-radius: 0;
	}
	.shared_btn {
		border-left: 0;
	}
	.uploader-list .ul-with-border li div.layout{
	display: block;
	width: 100%;
	}
	.uploader-list .ul-with-border li div.flex{
	display: block;
	width: 100%;
	max-width: 100%;
	}
	#carousel-view .fade-enter-active,
	#carousel-view .fade-leave-active,
	#carousel-view .fade-leave-to {
		transition: 0.3s ease-out;
		position: absolute;
		top: 0;
		left: 0;
	}

	#carousel-view .fade-enter,
	#carousel-view .fade-leave,
	#carousel-view .fade-leave-to {
		opacity: 0;
	}
	.carousel__item {
		display: -webkit-box;
		display: -ms-flexbox;
		display: flex;
		-webkit-box-align: center;
		-ms-flex-align: center;
		align-items: center;
		-webkit-box-pack: center;
		-ms-flex-pack: center;
		justify-content: center;
		-webkit-box-flex: 1;
		-ms-flex: 1 0 100%;
		flex: 1 0 100%;
		height: 100%;
		width: 100%;
		background-size: cover;
		background-position: 50%;
		-webkit-transition: .2s ease-out;
		-o-transition: .2s ease-out;
		transition: .2s ease-out;
	}
	body .carousel {
		margin-left: 0;
		margin-right: 0;
		height: 250px;
		width: 100%;
		position: relative;
		overflow: hidden;
		-webkit-box-shadow: 0px 3px 1px -2px rgba(0,0,0,0.2), 0px 2px 2px 0px rgba(0,0,0,0.14), 0px 1px 5px 0px rgba(0,0,0,0.12);
		box-shadow: 0px 3px 1px -2px rgba(0,0,0,0.2), 0px 2px 2px 0px rgba(0,0,0,0.14), 0px 1px 5px 0px rgba(0,0,0,0.12);

		box-shadow: none;
	}
	body .carousel__controls {

		width: 100%;
	}
	.row-header .toolbar__content {
		width: 100%
	}
	.overHidden{
		height: 260px!important;
		overflow: hidden!important
	}
	.btn-showmore{
		position: absolute;
		right: 30px;
		top:225px;
	}
	.btn-showmore:hover {
		cursor: pointer;
		color: #1976D2
	}
	.container-btn{
		position: absolute;
		right: 30px;
		bottom:0px;
	}
	.btn-showless{
		position: absolute;
		right: 30px;
		bottom: 20px;
	}
	.btn-showless:hover {
		cursor: pointer;
		color: #1976D2
	}
	.comments__container .card__text{
		padding-left: 0
	}
	.mx-datepicker{
        width: 100%!important
    }

</style>