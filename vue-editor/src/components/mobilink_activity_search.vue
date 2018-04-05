<template>
<div id="activitySearch">
    <v-slide-x-transition>
        <div>
            <v-layout wrap>
                
                <div class="row-header flex-break pl-2">
                    <v-flex style="max-width:50%">
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
                        item-value="employeeId"
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
                            <a href="javascript:;" title="Xem chi tiết" v-on:click="activityDetail(props.item,props.index)">
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
                        <v-chip style="display: inline-block;text-align: center;width:90%" label outline :color="getColor(props.item.state)"><span>{{props.item.stateName}}</span></v-chip>

                    </td>

                    <td class="text-xs-center">

                        <v-icon color="red darken-3" v-if="props.item.permission=='owner'||props.item.permission=='manager'" icon @click="deleteActivity(props.item,props.index,tableListItems)">clear</v-icon>
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
                
                /* Load data đơn vị tổ chức/ chủ trì */
                axios.get( endPoint + 'workingunits', config)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.hostingIdItems.push({
                                name: serializable.data[key].name,
                                workingUnitId: serializable.data[key].workingUnitId
                            })
                            
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })
                /* Load data employees */
                var paramsEmployees = {
                    active: true
                };
                const configEmployees = {
                    params: paramsEmployees,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( endPoint + 'employees', configEmployees)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.managerItems.push({
                                fullName: serializable.data[key].fullName,
                                employeeId: serializable.data[key].mappingUser?serializable.data[key].mappingUser.userId:''
                            })
                            
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })

                /* Load data địa chỉ*/
                axios.get( endPoint + 'locations', config)
                .then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.locationItems.push({
                                location: serializable.data[key].location,
                                locationId: serializable.data[key].locationId,
                            })
                            
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })
                    /* Load data dự án chương trình*/
                axios.get( endPoint + 'projects', config)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.projectItems.push({
                                projectName: serializable.data[key].projectName,
                                projectId: serializable.data[key].projectId
                            })
                            
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })
            },
            /** */
            
            getColor: function(item){
                var color;
                switch (item) {
                    case 1:
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
                    case 7:
                        color = "amber";
                        break;
                    case 8:
                        color = "grey";
                        
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
                vm.headersTable= [
                    {
                        text: '#',
                        align: 'left',
                        sortable: true,
                        value: 'activityId'
                    },
                    { 
                        text: 'Ngày bắt đầu',
                        align: 'left',
                        sortable: true,
                        value: 'time'
                    },
                    {
                        text: 'Hoạt động',
                        align: 'left',
                        sortable: true,
                        value: 'subject'
                    },
                    {
                        text: 'Loại hoạt động',
                        align: 'left',
                        sortable: true,
                        value: 'categoryName'
                    },
                    
                    {
                        text: 'Đơn vị thực hiện',
                        align: 'left',
                        sortable: true,
                        value: 'hosting'
                    },
                    {
                        text: 'Người phụ trách',
                        align: 'left',
                        sortable: true,
                        value: 'hosting'
                    },
                    {
                        text: 'Trạng thái',
                        align: 'left',
                        sortable: true,
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

                vm.status = vm.state?vm.state:'';
                vm.hostingId = vm.hosting?vm.hosting:'';
                vm.managerS = vm.manager?vm.manager:'';
                vm.projectS = vm.project?vm.project:'';
                vm.activityType = vm.type?vm.type:'';
                vm.locationS = vm.location?vm.location:'';
                vm.timeStart = vm.fromdate?new Date (vm.fromdate.slice(0,4)+'-'+vm.fromdate.slice(4,6)+'-'+ vm.fromdate.slice(6,8)):'';
                vm.timeEnd = vm.todate?new Date (vm.todate.slice(0,4)+'-'+vm.todate.slice(4,6)+'-'+ vm.todate.slice(6,8)):'';
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
                    sort:'startDate',
                    order:true
                };
                if(vm.keyS){
                    paramsTableActivity.keywords= vm.keyValue;
                    vm.textResult = '';
                    vm.textResult = "Từ khóa:"+vm.keyValue
                } else {
                    paramsTableActivity.state = vm.status?vm.status:'';
                    paramsTableActivity.hosting = vm.hostingId?vm.hostingId:'';
                    paramsTableActivity.manager = vm.managerS?vm.managerS:'';
                    paramsTableActivity.project = vm.projectS?vm.projectS:'';
                    paramsTableActivity.type = vm.activityType?vm.activityType:'';
                    paramsTableActivity.location = vm.locationS?vm.locationS:'';
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
                        return item.employeeId == vm.managerS;
                    })[0].fullName
                };
                if(vm.projectS){
                    var arr = vm.projectItems;
                    var projectT = arr.filter(function(item) {
                        return item.projectId == vm.projectS;
                    })[0].projectName
                };
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
                    'Dự án/chương trình: ' : projectT,
                    'Hoạt động: ' :activityTypeText
                    
                };
                
                vm.textResult = '';
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
                vm.projectS='';
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
                vm.bindAdvanceSearch();
                vm.getTableList();
                vm.viewAdvancedSearch = false;
                setTimeout(function(){
                    vm.getTxtSearch();
                },500)
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
        margin-left: 10px!important;
    }
    #activitySearch .row-header .input-group .input-group__details{
        display: none
    }
    #activitySearch .row-header .input-group label{
        top: 0px!important
    }
    #activitySearch #table_search table thead{
        background-color: #fff!important;
    }
    #activitySearch #table_search table thead tr th{
        border: 1px solid #ddd !important;
    }
    #activitySearch #table_search table tbody td {
        border: 1px solid #ddd !important;
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


