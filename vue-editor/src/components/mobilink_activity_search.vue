<template>
<div id="activitySearch">
    <v-slide-x-transition>
        <div>
            <v-layout wrap>
                
                <div class="row-header flex-break pl-2">
                    <v-flex style="max-width:50%" class="py-1">
                        <div :title="textResult" style="overflow: hidden;max-width:90%;
                        text-overflow: ellipsis;
                        white-space: nowrap;">{{textResult}} </div>
                        <span>Có {{tableListTotal}} kết quả</span>
                    </v-flex>
                    
                    <v-text-field class="pt-0" id="searchInput"
                        append-icon="search"
                        label="Nhập từ khóa"
                        single-line
                        hide-details
                        v-on:keyup.enter="search_by_keyOwn"
                        v-model="keySearch"
                    ></v-text-field>
                    <v-btn v-on:click.native="advancedSearch" class="px-0" style="height: 30px">
                        Tìm kiếm nâng cao
                    </v-btn>
 
                </div>
                
            </v-layout>
        </div>
    </v-slide-x-transition>

    <v-slide-y-transition>
        <div v-if="viewAdvancedSearch">
            <v-layout wrap class="mb-4">
                <!--  -->
                <v-flex xs12 sm2 class="mt-2 pl-3">
                    <v-subheader class="px-0">Từ ngày </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker @change="changeDate" v-bind:not-after="timeStartMax" class="mt-3" v-model="timeStart" placeholder="Chọn ngày" 
                    lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3 mt-2">
                    <v-subheader class="px-0">Đến ngày </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="pr-2">
                    <date-picker @change="changeDate" v-bind:not-before="timeEndMin" class="mt-3" v-model="timeEnd" placeholder="Chọn ngày" 
                    lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3">
                    <v-subheader class="px-0 pt-3" >Trạng thái</v-subheader>
                </v-flex>
                <v-flex xs12 sm4 id="statusTxt">
                    <v-select 
                        v-bind:items="statusItems"
                        v-model="status"
                        item-text="statusName"
                        item-value="statusCode"
                        autocomplete

                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                
                <!--  -->
                <v-flex xs12 sm2 class="pl-3">
                    <v-subheader class="px-0 pt-3">Đơn vị tổ chức/ chủ trì </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="pr-2">
                    <v-select 
                        v-bind:items="hostingIdItems"
                        v-model="hostingId"
                        item-text="name"
                        item-value="workingUnitId"
                        autocomplete
                        
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3">
                    <v-subheader class="px-0 pt-3">Người chủ trì/ phụ trách</v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select 
                        v-bind:items="managerItems"
                        v-model="managerS"
                        clearable
                        item-text="fullName"
                        item-value="userId"
                        autocomplete
                        
                        hide-selected
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3">
                    <v-subheader class="px-0 pt-3">Dự án/ chương trình</v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="pr-2" id="projectTxt">
                    <v-select 
                        v-bind:items="projectItems"
                        v-model="projectS"
                        clearable
                        item-text="projectName"
                        item-value="projectId"
                        autocomplete
                        
                        hide-selected
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3">
                    <v-subheader class="px-0 pt-3">Địa chỉ </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 id="locationTxt">
                    <v-select 
                        v-bind:items="locationItems"
                        v-model="locationS"
                        item-text="location"
                        item-value="locationId"
                        autocomplete
                        
                        hide-selected
                        clearable
                    >
                    </v-select>

                </v-flex>

                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0 pl-3 pt-3">Hoạt động</v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="pr-2" id="activityTypeTextxt">
                    <v-select 
                        v-bind:items="activityTypeItems"
                        v-model="activityType"
                        clearable
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete

                        hide-selected
                    ></v-select>
                </v-flex>
                <!--  -->
                
                <v-flex xs12 class="mt-3">
                    <div class="right">
                        <v-btn v-on:click.native="search_advancedOwn" class="primary">
                            <span v-lang.tim_kiem></span>
                        </v-btn>
                        <v-btn v-on:click.native="cancelAdvancedSearch" class="primary">
                            <span v-lang.huy></span>
                        </v-btn>
                    </div>
                </v-flex>
            </v-layout>
        </div>
    </v-slide-y-transition>

    <v-slide-x-transition>

        <v-data-table
        id = "table_search"
        no-data-text="Không có dữ liệu"
        :headers="headersTable"
        :items="tableListItems"
        :pagination.sync="pagination"
        prev-icon="mdi-menu-left"
        next-icon="mdi-menu-right"
        sort-icon="mdi-menu-down"
        :rows-per-page-text="rppt"
        :rows-per-page-items="rppi"
        >
            <template slot="items" slot-scope="props">
                <tr v-bind:class="{'active': props.index%2==1}">
                    <td class="text-xs-center">
                        <div class="pt-2 pb-2">
                            <span>{{props.item.activityId}}</span>
                        </div>
                    </td>

                    <td class="text-xs-center">
                        <div class="pt-2 pb-2">
                            <span>{{props.item.startDate|datetime}}</span>
                        </div>
                    </td>

                    <td>
                        <div class="pt-2 pb-2">
                            <a href="javascript:;" :title="props.item.subject" v-on:click="activityDetail(props.item,props.index)">
                                <span>{{props.item.subject}}</span>
                            </a>
                        </div>
                    </td>
                    
                    <td>
                        <div class="pt-2 pb-2">
                            <span>{{getActiviyType(props.item.activityType)}}</span>
                        </div>
                    </td>
                    
                    <td>
                        <div class="pt-2 pb-2">
                            <span>{{props.item.hosting}}</span>
                        </div>
                    </td>

                    <td>
                        <div class="pt-2 pb-2">
                            <span>{{props.item.managerName}}</span>
                        </div>
                    </td>

                    <td class="text-xs-center">
                        <v-chip style="display: inline-block;text-align: center;width:90%;height:30px" label outline 
                        :color="getColor(props.item.state)">
                            <span>{{props.item.stateName}}</span>
                        </v-chip>

                    </td>

                    <td class="text-xs-center">

                        <v-icon color="red darken-3" 
                        v-if="props.item.permission=='owner'||props.item.permission=='manager'||props.item.permission=='leader'||props.item.permission=='hoster'" icon 
                        @click="deleteActivity(props.item,props.index,tableListItems)">clear</v-icon>
                    </td>
                </tr>
            </template>

            <template slot="pageText" slot-scope="props">
                {{ props.pageStart }} - {{ props.pageStop }} của {{ props.itemsLength }} bản ghi
            </template>

            <v-alert slot="no-results" :value="true" color="error" icon="warning">
                Không có kết quả phù hợp!
            </v-alert>
        </v-data-table>

    </v-slide-x-transition>

</div>
</template>

<script>
    const COMPONENT_NAME = 'jx-mobilink-activity-search'
    export default {
        name: COMPONENT_NAME,
        props: {
            type:'',
            group_id: '',
            end_point: '',
            search:'',
            search_url: null,
            category:'',
            state:'',
            hosting:'',
            manager:'',
            project:'',
            location:'',
            fromdate:'',
            todate:''
        },
        created () {
            var vm = this;
            vm.$nextTick(function () {
                console.log(vm._props);
                var url = vm.search_url?(new URL(vm.search_url)).searchParams:null;
                if(url&&url.get("search")=='true'){
                    vm.search_advanced()
                }
            })
        },
        
        data () {
            return {
                timeStart: '',
                timeEnd: '',
                timeStartMax:'',
                timeEndMin:'',
                processTypeItems:[],
                processType:'',
                statusItems:[],
                status:'',
                topic:'',
                hostingIdItems:[],
                hostingId:'',
                address:'',
                projectItems:[],
                projectS:'',
                locationItems:[],
                locationS:'',
                contactItems:[],
                contact:'',
                managerItems:[],
                managerS:'',
                activityTypeItems:[
                    {itemName: 'Cuộc họp, hội nghị', itemCode: 'EVENT'},
                    {itemName: 'Giao nhiệm vụ', itemCode: 'TASK'},
                    {itemName: 'Đề xuất, kiến nghị', itemCode: 'REQUEST'},
                    {itemName: 'Kế hoạch công tác', itemCode: 'PLAN'},
                    {itemName: 'Yêu cầu hỗ trợ', itemCode: 'TICKET'}
                ],
                activityType:'',
                viewAdvancedSearch: false,
                startDate:'...',
                endDate: '...',
                keySearch:'',
                keyS: false,
                keyValue:'',
                textResult:'',
                isOverdue: '',
                startend:'',
                categoryS:'',
                follow:'',

                tableListTotal: 0,
                tableListItems:[],
                headersTable: [],
                pagination: {
                    rowsPerPage: 10
                },
                rppt: "Hiển thị",
                rppi: [10,20,30,{"text":"All","value":-1}]
            }
        },
        methods: {
            /**Load data for form search */
            getDataFormS: function(){
                var vm = this;
                vm.statusItems = [
                    {
                        statusName: 'Mới',
                        statusCode: 1
                    },
                    {
                        statusName: 'Xin chỉ đạo',
                        statusCode: 2
                    },
                    {
                        statusName: 'Chờ thực hiện',
                        statusCode: 3
                    },
                    {
                        statusName: 'Đang thực hiện',
                        statusCode: 4
                    },
                    {
                        statusName: 'Chờ xác nhận',
                        statusCode: 5
                    },
                    {
                        statusName: 'Đang theo dõi',
                        statusCode: 6
                    },
                    {
                        statusName: 'Đã kết thúc',
                        statusCode: 7
                    },
                    {
                        statusName: 'Đã hủy',
                        statusCode: 8
                    },
                    {
                        statusName: 'Không xử lý',
                        statusCode: 9
                    }
                ];
                
                var endPoint = vm.end_point;
                /** */
                var paramsBuilder = {
                    
                };
                const config = {
                    params: paramsBuilder,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                var paramsTypeProcess = {
                    sort: "treeIndex"
                };
                const configTypeProcess = {
                    params: paramsTypeProcess,
                    headers: {
                        'groupId': vm.group_id
                    }

                };
                
                var paramsGetEmployee = {
                    'class': 'employee'
                };
                const configGetEmployee = {
                    params: paramsGetEmployee,
                    headers: {
                        'groupId': vm.group_id
                    }
                };

                axios.all([
                    axios.get(vm.end_point + 'workingunits', config),
                    axios.get( vm.end_point + 'users', configGetEmployee),
                    axios.get( vm.end_point + 'locations', config),
                    // axios.get( vm.end_point + 'projects', config)
                ])
                .then(axios.spread(function(workingUnitRespones, userRespones, locationRespones) {
                    var serializable = workingUnitRespones.data;
                    var serializable1 = userRespones.data;
                    var serializable2 = locationRespones.data;
                    // var serializable3 = projectsRespone.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.hostingIdItems.push({
                                name: serializable.data[key].name,
                                workingUnitId: serializable.data[key].workingUnitId
                            })
                            
                        }
                    }
                    if (serializable1.hasOwnProperty('data')) {
                        for (var key in serializable1.data) {
                            vm.managerItems.push(
                                serializable1.data[key]
                            )
                        }
                    }
                    if (serializable2.hasOwnProperty('data')) {
                        for (var key in serializable2.data) {
                            vm.locationItems.push({
                                location: serializable2.data[key].location,
                                locationId: serializable2.data[key].locationId,
                            })
                            
                        }
                    }
                    // if (serializable3.hasOwnProperty('data')) {
                    //     for (var key in serializable3.data) {
                    //         vm.projectItems.push({
                    //             projectName: serializable3.data[key].projectName,
                    //             projectId: serializable3.data[key].projectId
                    //         })
                            
                    //     }
                    // };
                    if(!vm.keyS){
                        vm.bindAdvanceSearch();
                        vm.getTableList();
                        vm.viewAdvancedSearch = false;
                        setTimeout(function(){
                            vm.getTxtSearch();
                        },500)
                    }
                    
                }))
            },
            /** */
            
            getColor: function(item){
                var color;
                switch (item) {
                    case 1:
                        color = "red";
                        break;
                    case 2:
                        color = "red";
                        break;
                    case 3:
                        color = "red";
                        break;
                    case 4:
                        color = "blue";
                        break;
                    case 5:
                        color = "blue";
                        break;
                    case 6:
                        color = "teal";
                        break;
                    case 7:
                        color = "amber";
                        break;
                    case 8:
                        color = "grey";
                        break;
                    case 9:
                        color = "pink";
                        break;
                    case 10:
                        color = "cyan";
                        break;
                    case 11:
                        color = "purple";
                        break;
                    case 12:
                        color = "indigo";
                        break;
                        
                }
                return color
            },
            changeDate: function(){
                var vm = this;
                setTimeout(function(){
                    vm.timeEndMin = vm.timeStart?new Date(vm.timeStart):'';
                    vm.timeStartMax = vm.timeEnd?new Date(vm.timeEnd):'';
                },200)
                
            },
            /** */
            getActiviyType: function(item){
                var type;
                switch (item) {
                    case 'EVENT':
                        type = "Sự kiện";
                        break;
                    case 'TASK':
                        type = "Nhiệm vụ";
                        break;
                    case 'REQUEST':
                        type = "Yêu cầu";
                        
                }
                return type
            },
            /**onload function */
            init: function(){
                var vm = this;
                console.log(vm._props);
                vm.headersTable= [
                    {
                        text: '#',
                        align: 'left',
                        sortable: false,
                        value: 'activityId'
                    },
                    { 
                        text: 'Ngày bắt đầu',
                        align: 'left',
                        sortable: false,
                        value: 'time'
                    },
                    {
                        text: 'Hoạt động',
                        align: 'left',
                        sortable: false,
                        value: 'subject'
                    },
                    {
                        text: 'Loại hoạt động',
                        align: 'left',
                        sortable: false,
                        value: 'categoryName'
                    },
                    
                    {
                        text: 'Đơn vị thực hiện',
                        align: 'left',
                        sortable: false,
                        value: 'hosting'
                    },
                    {
                        text: 'Người phụ trách',
                        align: 'left',
                        sortable: false,
                        value: 'hosting'
                    },
                    {
                        text: 'Trạng thái',
                        align: 'left',
                        sortable: false,
                        value: 'hosting'
                    },
                                        
                    {
                        text: '',
                        sortable: false,
                        align: 'left',
                        value: 'clear'
                    }
                ];
            },

            /**show search advanced */
            advancedSearch: function () {
                var vm = this;
                // vm.processTypeItems = []
                vm.viewAdvancedSearch = !vm.viewAdvancedSearch;
            },
            /**bind props */
            bindAdvanceSearch: function(){
                var vm =this;
                var url = vm.search_url?(new URL(vm.search_url)).searchParams:null;
                if(url&&url.get("search")=='true'){
                    vm.status = (url.has("state")?url.get("state"):'')?Number(url.get("state")):'';
                    vm.hostingId = (url.has("hosting")?url.get("hosting"):'')?Number(url.get("hosting")):'';
                    vm.managerS = (url.has("manager")?url.get("manager"):'')?Number(url.get("manager")):'';
                    // vm.projectS = (url.has("project")?url.get("project"):'')?Number(url.get("project")):'';
                    vm.activityType = url.has("type")?url.get("type"):'';
                    vm.locationS = (url.has("location")?url.get("location"):'')?Number(url.get("location")):'';
                    vm.timeStart = url.has("fromdate")?new Date (url.get("fromdate").slice(0,4)+'-'+url.get("fromdate").slice(4,6)+'-'+ url.get("fromdate").slice(6,8)):'';
                    vm.timeEnd = url.has("todate")?new Date (url.get("todate").slice(0,4)+'-'+url.get("todate").slice(4,6)+'-'+ url.get("todate").slice(6,8)):'';
                    vm.isOverdue = url.has("isOverdue")?url.get("isOverdue"):'';
                    vm.startend = url.has("startend")?url.get("startend"):'';
                    vm.categoryS = url.has("category")?url.get("category"):'';
                    vm.follow = url.has("follow")?url.get("follow"):'';
                } else {
                    vm.status = vm.state?vm.state:'';
                    vm.hostingId = vm.hosting?vm.hosting:'';
                    vm.managerS = vm.manager?vm.manager:'';
                    // vm.projectS = vm.project?vm.project:'';
                    vm.activityType = vm.type?vm.type:'';
                    vm.locationS = vm.location?vm.location:'';
                    vm.timeStart = vm.fromdate?new Date (vm.fromdate.slice(0,4)+'-'+vm.fromdate.slice(4,6)+'-'+ vm.fromdate.slice(6,8)):'';
                    vm.timeEnd = vm.todate?new Date (vm.todate.slice(0,4)+'-'+vm.todate.slice(4,6)+'-'+ vm.todate.slice(6,8)):'';
                }
                
            },
            /**filter get text search */
            filterText: function(arr,key,value){
                arr.filter(function(item) {
                    return item.key == value;
                })
            },
            /**load table */
            getTableList: function () {
                var vm = this;
                var endPoint = vm.end_point;
                var paramsTableActivity = {
                    sort:'startDate_Number',
                    order:true
                };
                if(vm.keyS){
                    paramsTableActivity.keywords= vm.keyValue;
                    vm.textResult = '';
                    vm.textResult = "Từ khóa:"+vm.keyValue
                } else {
                    paramsTableActivity.state = vm.status?vm.status:null;
                    paramsTableActivity.hosting = vm.hostingId?vm.hostingId:null;
                    paramsTableActivity.leader = vm.managerS?vm.managerS:null;
                    // paramsTableActivity.project = vm.projectS?vm.projectS:'';
                    paramsTableActivity.type = vm.activityType?vm.activityType:null;
                    paramsTableActivity.isOverdue = vm.isOverdue?vm.isOverdue:null;
                    paramsTableActivity.startend = vm.startend?vm.startend:null;
                    paramsTableActivity.follow = vm.follow?vm.follow:null;
                    paramsTableActivity.category = vm.categoryS?vm.categoryS:null;
                    paramsTableActivity.location = vm.locationS?vm.locationS:null;
                    paramsTableActivity.fromdate = vm.parseDateFormat(vm.timeStart);
                    paramsTableActivity.todate = vm.parseDateFormat(vm.timeEnd);
                    
                    vm.startDate = vm.timeStart?vm.parseDateView(vm.timeStart):'';
                    vm.endDate = vm.timeEnd?vm.parseDateView(vm.timeEnd):'';
                    
                }
                
                var configGetActivity = {
                    params: paramsTableActivity,
                    headers: {
                        groupId: vm.group_id
                    }
                };
                var url = endPoint + 'activities';
                axios.get(url, configGetActivity).then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data') && Array.isArray(serializable.data)) {
                        vm.tableListItems = serializable.data;
                        vm.tableListTotal = serializable.total;
                    }  else {
                        vm.tableListItems = [];
                        vm.tableListTotal = 0;
                    }
                })
                .catch(function (error) {
                    console.log(error);
                    vm.tableListItems = [];
                });
                console.log(vm)
            },
            /**get text search */
            getTxtSearch: function(){
                var vm = this;
                if(vm.hostingId){
                    var arr = vm.hostingIdItems;
                    var hostingT = arr.filter(function(item) {
                        return item.workingUnitId == vm.hostingId;
                    })[0].name
                };
                
                if(vm.status){
                    var arr = vm.statusItems;
                    var stateT = arr.filter(function(item) {
                        return item.statusCode == vm.status;
                    })[0].statusName
                };
                if(vm.locationS){
                    var arr = vm.locationItems;
                    var locationT = arr.filter(function(item) {
                        return item.locationId == vm.locationS;
                    })[0].location
                };
                if(vm.managerS){
                    var arr = vm.managerItems;
                    var managerT = arr.filter(function(item) {
                        return item.userId == vm.managerS;
                    })[0].fullName
                };
                // if(vm.projectS){
                //     var arr = vm.projectItems;
                //     var projectT = arr.filter(function(item) {
                //         return item.projectId == vm.projectS;
                //     })[0].projectName
                // };
                if(vm.activityType){
                    var arr = vm.activityTypeItems;
                    var activityTypeText = arr.filter(function(item) {
                        return item.itemCode == vm.activityType;
                    })[0].itemName
                };
                var textShow = {
                    'Từ ngày: ': vm.startDate,
                    'Đến ngày: ': vm.endDate,
                    'Trạng thái: ' : stateT,
                    'Đơn vị tổ chức: ' : hostingT,
                    'Địa chỉ: ' : locationT,
                    'Người chủ trì/ phụ trách: ': managerT,
                    // 'Dự án/chương trình: ' : projectT,
                    'Hoạt động: ' :activityTypeText
                    
                };
                var url = vm.search_url?(new URL(vm.search_url)).searchParams:null;
                if(url&&url.get("search")=='true'&&url.has("keywords")){
                    vm.textResult = 'Từ khóa:'+url.get("keywords");
                } else {vm.textResult = ''}
                
                for(var key in textShow){
                    if(textShow[key]){
                        var txt = key+textShow[key]+'; ';
                        vm.textResult+=txt
                    }
                };

            },
            /** search by key */
            search_by_key: function(){
                
                var vm = this;
                vm.keyS = true;
                vm.keyValue = vm.search;
                vm.init();
                vm.getTableList();
                vm.getDataFormS();
            },
            /** search by keyOwn */
            search_by_keyOwn: function(){
                
                var vm = this;
                vm.keyS = true;
                vm.keyValue = vm.keySearch;
                vm.timeStart='';
                vm.timeEnd ='';
                // vm.projectS='';
                vm.status = '';
                vm.hostingId = '';
                vm.managerS = '';
                vm.activityType = '';
                vm.locationS = '';
                vm.getTableList();
                
            },
            /** search advanced */
            search_advanced: function(){
                var vm = this;
                vm.keyS = false;
                vm.init();
                vm.getDataFormS();
            },
            /** search advancedOwn */
            search_advancedOwn: function(){
                var vm = this;
                vm.keyS = false;
                vm.getTableList();
                vm.viewAdvancedSearch = false;
                vm.keySearch = '';
                setTimeout(function(){
                    vm.getTxtSearch();
                },500)
            },
            /**Load activity detail */
            activityDetail: function(item, index){
                this.$emit('view_detail', item, index);
            },
            /**delete activity */
            deleteActivity: function (item, index, items) {
                this.$emit('delete_activity', item, index, items);
            },

            cancelAdvancedSearch:function(){
                var vm = this;
                vm.viewAdvancedSearch = false;
            },
            parseDateFormat : function(fullDate){
                var date;
                if(fullDate){
                    date = fullDate.getFullYear()+(fullDate.getMonth()+1).toString().padStart(2, '0')+fullDate.getDate().toString().padStart(2, '0');
                } else {
                    date = ""
                }
                return date
            },
            parseDateView : function(fullDate){
                var date;
                if(fullDate){
                    date = fullDate.getDate().toString().padStart(2, '0')+'/'+(fullDate.getMonth()+1).toString().padStart(2, '0')+'/'+fullDate.getFullYear();
                } else {
                    date = ""
                }
                return date
            },
            formatDate (date) {
                if (!date) {
                    return null
                }
                const [year, month, day] = date.split('-')
                return `${day}/${month}/${year}`
            },
        }

    }
</script>

<style>
    
    #activitySearch .row-header {
        background-color: #3486D7!important;
        color: #ffffff!important;
        overflow: hidden;
        display: -webkit-flex;
        display: flex;
        align-items: center;
        width: 100%;
    }
    #activitySearch .row-header .input-group .input-group__input{
        background-color: #ffffff!important;
        margin-top: 0px!important;
        padding-left: 3px!important;
        border-radius: 2px!important;
        color: #3486D7 !important;
    }
    #activitySearch .row-header .input-group label{
        font-weight: normal!important;
    }
    #activitySearch .row-header .input-group .input-group__details{
        display: none
    }
    #activitySearch table tfoot{
        display: none
    }
    #activitySearch .row-header .input-group label{
        top: 0px!important
    }
    #activitySearch .row-header button{
        background-color: #01579b;
        color: white;
        text-transform: none;
    }
    
    #activitySearch #table_search table thead{
        background-color: #fff!important;
    }
    #activitySearch #table_search table thead tr th{
        border: 1px solid #ddd !important;
        color: #000!important
    }
    #activitySearch #table_search table tbody td {
        border: 1px solid #ddd !important;
    }
    #activitySearch #table_search table tbody td a:hover {
        color: blue!important
    }
    #activitySearch .mx-datepicker{
        width: 100%!important
    }


    /* CSS Hoàn bổ sung */
    body #activitySearch table.table td{
            padding: 0 5px!important;
    }
    #activitySearch table.table td i{
        cursor: pointer;
    }
    body #activitySearch table.table th{
        text-align: center!important;
    }
    #activitySearch table.table td i{
        font-size: 13px;
    }
    #activitySearch table.table td button{
        width: 30px;
        height: 30px;
    }
    body #activitySearch table.table td:nth-child(1) div,body #activitySearch table.table td:nth-child(2) div,body #activitySearch table.table td:nth-child(3) div,body #activitySearch table.table td:nth-child(4) div,body #activitySearch table.table td:nth-child(5) div,body #activitySearch table.table td:nth-child(6) div,body #activitySearch table.table td:nth-child(7) div{
            overflow: hidden;
            text-overflow: ellipsis; 
            white-space: nowrap; 
            width: 90%!important;
            position: absolute;
        }
        body #activitySearch table.table th:nth-child(1),body #activitySearch table.table td:nth-child(1) {
            width: 3%!important;
            position: relative;
        }
        body #activitySearch table.table th:nth-child(2),body #activitySearch table.table td:nth-child(2) {
            width: 10%!important;
            position: relative;
        }
        body #activitySearch table.table th:nth-child(3),body #activitySearch table.table td:nth-child(3) {
            width: 25%!important;
            position: relative;
        }
        body #activitySearch table.table th:nth-child(4),body #activitySearch table.table td:nth-child(4) {
            width: 19%!important;
            position: relative;
        }
        body #activitySearch table.table th:nth-child(5),body #activitySearch table.table td:nth-child(5) {
            width: 15%!important;
            position: relative;
        }
        body #activitySearch table.table th:nth-child(6),body #activitySearch table.table td:nth-child(6) {
            width: 15%!important;
            position: relative;
        }
        body #activitySearch table.table th:nth-child(7),body #activitySearch table.table td:nth-child(7) {
            width: 10%!important;
            position: relative;
        }
        body #activitySearch table.table th:nth-child(8),body #activitySearch table.table td:nth-child(8){
            width: 3%!important;
        }

        body #activitySearch .datatable__actions__select,body #activitySearch .datatable__actions__pagination{
            display: none;
        }
        body #activitySearch table.table td div{
            margin-top: 4px;
        }

</style>


