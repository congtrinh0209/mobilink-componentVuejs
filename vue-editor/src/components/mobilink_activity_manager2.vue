<template>

    <div id="activity_manager">
        <v-layout wrap class="navTable px-3 py-3">
            <v-flex xs2 sm2>
                <v-subheader class="px-0">Nhóm theo: </v-subheader>
            </v-flex>
            <v-flex xs10 sm10 class="pt-2">
                <v-radio-group v-model="radioGroup" @change="changeGroup" row class="py-0 groupRadido">
                    <v-radio class="my-0" label="Lãnh đạo" color="secondary"
                        value="leader">
                    </v-radio>
                    <!-- <v-radio class="my-0" label="Đơn vị chủ trì" color="secondary"
                        value="workingUnit">
                    </v-radio> -->
                    <v-radio class="my-0" label="Lĩnh vực/ nhóm" color="secondary"
                        value="activityCat">
                    </v-radio>
                </v-radio-group>
            </v-flex>
            <v-flex xs12 sm1 class="mt-2">
                <v-subheader class="px-0">Từ ngày: </v-subheader>
            </v-flex>
            <v-flex xs12 sm3 class="pr-3">
                <date-picker class="mt-3" v-model="timeStart" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
            </v-flex>
            <v-flex xs12 sm1 class="mt-2">
                <v-subheader class="px-0">Đến ngày: </v-subheader>
            </v-flex>
            <v-flex xs12 sm3>
                <date-picker class="mt-3" v-model="timeEnd" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
            </v-flex>
            <!-- <v-flex xs12 sm2 class="mt-2">
                <v-subheader class="px-0">Lọc theo lãnh đạo: </v-subheader>
            </v-flex> -->
            <v-flex xs12 sm4 class="pt-3 pr-3" style="display:none">
                <v-select class="selectBoder py-0"
                    v-bind:items="managerItems"
                    v-model="manager"
                    return-object
                    clearable
                    item-text="fullName"
                    item-value="employeeId"
                    autocomplete
                    placeholder="Lọc theo lãnh đạo"
                    @change="getFilterLeader"
                ></v-select>
            </v-flex>
            <!-- <v-flex xs12 sm2 class="mt-2">
                <v-subheader class="px-0">Lọc theo đơn vị chủ trì: </v-subheader>
            </v-flex> -->
            <v-flex xs12 sm4 class="pt-3 pr-3" style="display:none">
                <v-select class="selectBoder py-0"
                    v-bind:items="hostingIdItems"
                    v-model="hostingId"
                    item-text="name"
                    item-value="workingUnitId"
                    return-object
                    autocomplete
                    placeholder="Lọc theo đơn vị chủ trì"
                    @change="getFilterWorkingUnit"
                    clearable
                ></v-select>
            </v-flex>

            <v-flex xs12 sm4 class="pt-3" style="display:none">
                <v-select class="selectBoder py-0"
                    v-bind:items="hostingIdItems"
                    v-model="hostingId"
                    item-text="name"
                    item-value="workingUnitId"
                    return-object
                    autocomplete
                    placeholder="Lọc theo lĩnh vực/ nhóm"
                    @change="getFilterWorkingUnit"
                    clearable
                ></v-select>
            </v-flex>
            
        </v-layout>
        <div v-for="item in mainItems" :key="item.leader.employeeId">
            <v-expansion-panel expand>
                <v-expansion-panel-content value="true">
                    <div slot="header" class="custome-panel-heading-with-icon mr-2 pl-0">
                        <div>Đồng chí {{ item.leader.fullName }} - {{ item.leader.jobTitle }}</div>
                    </div>
                    
                    <v-card class="pl-2 pr-1">
                        <v-card-text class="px-0 py-0">
                            <v-layout row wrap class="mx-0">
                                
                                <v-flex xs12 sm12>
                                    <v-card>
                                        <v-list >
                                            
                                            <v-list-group v-for="item1 in item.activityItems" :value="item1.active" v-bind:key="item1.userId">
                                                <!-- Phần danh sách tổ chức/ đơn vị -->
                                                <v-list-tile slot="item" class="px-0">
                                                    <v-list-tile-content class="px-0">
                                                        <v-flex xs12 class="layout wrap">
                                                            <v-flex xs6 sm9 class="pt-2">
                                                                <v-list-tile-title class="item_group">
                                                                    {{ parseDateView(item1.startDate)}} - {{item1.resultNote}}
                                                                </v-list-tile-title>
                                                                
                                                            </v-flex>
                                                            
                                                        </v-flex>
                                                        <v-divider xs12 class="my-0"></v-divider>
                                                        
                                                    </v-list-tile-content>
                                                    
                                                </v-list-tile>
                                                
                                                <!-- end -->

                                                <!-- Phần danh sách cá nhân trong tổ chức/ đơn vị -->
                                                <v-list-tile v-for="item2 in item.activitySourceItems" v-bind:key="item2.userId">
                                                    <v-list-tile-content class="mt-2">
                                                        <v-flex xs12 class="layout wrap">
                                                            
                                                            <v-flex xs12 sm6 class="pt-1">
                                                                <v-list-tile-title>
                                                                    <span class="pt-2">{{ item2.fullname }}</span>
                                                                </v-list-tile-title>
                                                            </v-flex>
                                                            
                                                        </v-flex>

                                                    </v-list-tile-content>  
                                                </v-list-tile>
                                                <!-- end -->
                                                <v-divider class="mt-0"></v-divider>

                                            </v-list-group>
                                        </v-list>
                                    </v-card>
                                </v-flex>
                            </v-layout>
                        </v-card-text>
                    </v-card>
                </v-expansion-panel-content>
            </v-expansion-panel>
            <!--  -->
        </div>

    </div>
</template>


<script>
    const COMPONENT_NAME = 'jx-mobilink-activity-manager'

    export default {
        name: COMPONENT_NAME,
        props: {
            class_pk: null,
            class_name: null,
            group_id: null,
            end_point: null,
        },

        created () {
            var vm = this
            vm.$nextTick(function () {
                vm.getManager();
                vm.getWorkingUnit();
                setTimeout(function(){
                    vm.getActivity()
                },1000)
                
            })
        },
        
        data () {
            return {
                class_name: "org.mobilink.activitymgt.model.Activity",
                mainItems: [
                    {
                        'leader' :{name:'Trịnh Công Trình', userId: 101},
                        activityItems :[
                            {date:'Trịnh Công Trình0', userId: 1},
                            {date:'Nguyễn Văn Thành0', userId: 2},
                            {date:'Trịnh Công Trình0', userId: 3},
                            {date:'Nguyễn Văn Thành0', userId: 4}
                        ],
                        activitySourceItems: [
                            {fullname:'Trịnh Công Trình1', userId: 1},
                            {fullname:'Nguyễn Văn Thành1', userId: 2},
                            {fullname:'Trịnh Công Trình1', userId: 3},
                            {fullname:'Nguyễn Văn Thành1', userId: 4}
                        ]
                    },
                    {
                        'leader' :{name:'Nguyễn Văn Thành', userId: 101},
                        activityItems :[
                            {date:'Trịnh Công Trình01', userId: 1},
                            {date:'Nguyễn Văn Thành01', userId: 2},
                            {date:'Trịnh Công Trình01', userId: 3},
                            {date:'Nguyễn Văn Thành01', userId: 4}
                        ],
                        activitySourceItems: [
                            {fullname:'Trịnh Công Trình2', userId: 1},
                            {fullname:'Nguyễn Văn Thành2', userId: 2},
                            {fullname:'Trịnh Công Trình2', userId: 3},
                            {fullname:'Nguyễn Văn Thành2', userId: 4}
                        ]
                    }
                ],
                
                userId: '',
                activityListItems:[],
                radioGroup:'leader',
                managerItems: [],
                manager:'',
                hostingIdItems:[],
                hostingId:'',
                timeStart:'',
                timeEnd:'',
                mainItems: [],
                subItems: [],
                paramsGet: {},
                mainHeaders: [
                    {
                        text: 'STT',
                        align: 'center',
                        value:'activityId',
                        sortable: false
                    },
                    { 
                        text: 'Nội dung',
                        align: 'center',
                        value: 'subject',
                        sortable: false
                    },
                    {
                        text: 'Đơn vị chủ trì',
                        align: 'center',
                        value: 'hosting',
                        sortable: false
                    },
                    {
                        text: 'Hạn hoàn thành',
                        align: 'center',
                        value: 'endDate',
                        sortable: false
                    },
                    {
                        text: 'Trạng thái',
                        align: 'center',
                        value: 'stateName',
                        sortable: false
                    },
                    {
                        text: 'Ghi chú',
                        align: 'center',
                        value: 'resultNote',
                        sortable: false
                    }
                ]
                
            }
        },
        methods: {
            /* Load data lãnh đạo */
            getManager: function(){
                console.log("run get mamager");
                var vm = this;
                var paramsEmployees = {
                    active: true
                };
                const configEmployees = {
                    params: paramsEmployees,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'employees', configEmployees)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.managerItems.push(
                                serializable.data[key]
                            )
                            
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })
            },
            /* Load data đơn vị chủ trì */
            getWorkingUnit: function(){
                console.log("run get working unit");
                var vm = this;
                var paramsWorkingUnit = {
                    
                };
                const configWorkingUnit = {
                    params: paramsWorkingUnit,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'workingunits', configWorkingUnit)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.hostingIdItems.push(serializable.data[key])
                        };
                        

                    }
                })
                .catch(function (error) {
                    console.log(error)
                })
            },
            /* Load data activity */
            getActivity: function(){
                var vm = this;
                vm.activityListItems=[];
                var paramsGetActivity = {
                    sort:'startDate',
                };
                vm.paramsGet = paramsGetActivity;
                var configGetActivity = {
                    params: vm.paramsGet,
                    headers: {
                        groupId: vm.group_id
                    }
                };
                var url = vm.end_point + 'activities';
                axios.get(url, configGetActivity).then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            if(serializable.data[key].activityType == 'EVENT' ||serializable.data[key].activityType == 'TASK'){
                                vm.activityListItems.push(serializable.data[key])
                            }
                            
                        };
                        if(vm.radioGroup=='activityCat'){
                            vm.getListItemGroup(vm.hostingIdItems);
                            vm.getListActivitySource(vm.activityItems[0].activityId,0)
                        } else if(vm.radioGroup=='leader') {
                            vm.getListItemGroup(vm.managerItems);
                            vm.getListActivitySource(vm.activityItems[0].activityId,0)
                        };
                        
                    }else {
                        vm.activityListItems = [];
                    }
                    console.log(vm)
                })
                .catch(function (error) {
                    console.log(error);
                    vm.activityListItems = [];
                });
            },
            callGetActivity: function(){
                var vm = this;
                var configGetActivity = {
                    params: vm.paramsGet,
                    headers: {
                        groupId: vm.group_id
                    }
                };
                var url = vm.end_point + 'activities';
                axios.get(url, configGetActivity).then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.activityListItems.push(serializable.data[key])
                        };
                        if(vm.radioGroup=='workingUnit'){
                            vm.getListItemGroup(vm.hostingIdItems);
                            vm.getListActivitySource(vm.activityItems[0].activityId,0)
                        } else if(vm.radioGroup=='leader') {
                            vm.getListItemGroup(vm.managerItems);
                            vm.getListActivitySource(vm.activityItems[0].activityId,0)
                        };
                        
                    }else {
                        vm.activityListItems = [];
                    }
                    console.log(vm)
                })
                .catch(function (error) {
                    console.log(error);
                    vm.activityListItems = [];
                });
            },
            /**Lọc theo leader */
            changeGroup: function(){
                var vm = this;
                vm.timeStart = '';
                vm.timeEnd= '';
                vm.hostingId = '';
                vm.manager = '';
                vm.getActivity()
            },
            /**Lọc theo leader */
            getFilterLeader: function(){
                var vm = this;
                setTimeout(function(){
                    vm.paramsGet.leader  = vm.manager.employeeId;
                    vm.callGetActivity();
                },200)
            },
            /**Lọc theo đơn vị */
            getFilterWorkingUnit: function(){
                var vm = this;
                setTimeout(function(){
                    vm.paramsGet.hosting  = vm.hostingId.workingUnitId;
                    vm.callGetActivity();
                },200)
            },
            /**get list leader group */
            getListItemGroup: function(target){
                var vm = this;
                vm.mainItems =[];
                vm.subItems =[];
                for(var key in target) {
                    for(var index in vm.activityListItems){
                        if(vm.radioGroup == "activityCat"){
                            if(target[key].workingUnitId == vm.activityListItems[index].hostingId){
                                vm.mainItems.push(
                                    {
                                        'leader': item,
                                        activityItems: [],
                                        activitySourceItems:[]
                                    }
                                );
                                
                                break;
                            }
                        } else if(vm.radioGroup == "leader"){
                            if(target[key].mappingUser.userId == vm.activityListItems[index].leaderId){
                                vm.mainItems.push(
                                    {
                                        'leader': item,
                                        activityItems: [],
                                        activitySourceItems:[]
                                    }
                                );
                                break;
                            }
                            
                        }
                        
                    }
                }
            },
            /**get list activity group */
            getListActivityItemsGroup: function(){
                var vm =this;
                for(var key in vm.mainItems) {
                    for(var index in vm.activityListItems){
                        if(vm.radioGroup == "workingUnit"&&vm.mainItems.length!=0){
                            if(vm.activityListItems[index].hostingId == vm.mainItems[key].workingUnitId){
                                vm.mainItems[key].activityItems.push(vm.activityListItems[index]);
                            }
                        } else if(vm.radioGroup == "leader"&&vm.mainItems.length!=0){
                            if(vm.activityListItems[index].leaderId == vm.mainItems[key].mappingUser.userId){
                                vm.mainItems[key].activityItems.push(vm.activityListItems[index]);
                            }
                        }
                        
                        
                    }
                }
            },
            /** get list source group*/
            getListActivitySource: function(class_pk,index){
                var vm =this;
                var paramsGetSource = {
                    
                };
                const configGetSource = {
                    params: paramsGetSource,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'activities/source/'+vm.class_name+'/'+class_pk, configGetSource)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.mainItems[index].activitySourceItems.push(
                                serializable.data[key]
                            )
                          
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })
            },
            getKeyGroup: function(radio){
                if(radio=="workingUnit"){
                    return 'workingUnitId'
                } else if(radio=="leader"){
                    return 'employeeId'
                }
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
            /** */
            getState: function(item){
                var state;
                switch (item) {
                    case 0:
                        state = "Mới";
                        break;
                    case 1:
                        state = "Đang xử lý";
                        break;
                    case 2:
                        state = "Hoàn thành";
                        break;
                    case 3:
                        state = "Đã hủy";
                        
                }
                return state
            },
            getColor: function(item){
                var color;
                switch (item) {
                    case 0:
                        color = "red";
                        break;
                    case 1:
                        color = "blue";
                        break;
                    case 2:
                        color = "amber";
                        break;
                    case 3:
                        color = "grey";
                        
                }
                return color
            },
        }

    }
</script>

<style>
    #activity_manager .navTable{
        background-color: #96c1ec!important;
    }
    #activity_manager .groupRadido .radio{
        max-width: 150px !important;
    }
    #activity_manager .input-group .input-group__details{
        display: none
    }
    #activity_manager .navTable .selectBoder{
        background-color: #ffffff!important;
        padding-left: 10px!important;
        border-radius: 2px!important;
        height: 34px!important;
    }

    #activity_manager .mx-datepicker{
        width: 100%!important
    }


</style>

