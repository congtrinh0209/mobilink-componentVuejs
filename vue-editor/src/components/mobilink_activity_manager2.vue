<template>

    <div id="activity_manager">
        <v-layout wrap class="navTable px-3 py-3">
            <v-flex xs2 sm1>
                <v-subheader class="px-0">Nhóm theo: </v-subheader>
            </v-flex>
            <v-flex xs10 sm11 class="pt-2 pl-4">
                <v-radio-group v-model="radioGroup" @change="changeGroup" row class="py-0 groupRadido">
                    <v-radio class="my-0" label="Lãnh đạo" color="secondary"
                        value="leader">
                    </v-radio>
                    <!-- <v-radio class="my-0" label="Đơn vị chủ trì" color="secondary"
                        value="activityCat">
                    </v-radio> -->
                    <v-radio class="my-0" label="Lĩnh vực/ nhóm" color="secondary"
                        value="activityCat">
                    </v-radio>
                </v-radio-group>
            </v-flex>
            <v-flex xs12 sm1 class="mt-2">
                <v-subheader class="px-0">Từ ngày: </v-subheader>
            </v-flex>
            <v-flex xs12 sm3 class="pr-3 pl-4">
                <date-picker @change="changeDate" class="mt-3" v-model="timeStart" 
                v-bind:not-after="timeStartMax" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
            </v-flex>
            <v-flex xs12 sm1 class="mt-2">
                <v-subheader class="px-0">Đến ngày: </v-subheader>
            </v-flex>
            <v-flex xs12 sm3>
                <date-picker @change="changeDate" class="mt-3" v-model="timeEnd" 
                v-bind:not-before="timeEndMin" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
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

            <v-flex xs12 sm4 class="pt-3" style="display:none">
                <v-select class="selectBoder py-0"
                    v-bind:items="activityCatItems"
                    v-model="activityCat"
                    item-text="itemName"
                    item-value="itemCode"
                    return-object
                    autocomplete
                    placeholder="Lọc theo lĩnh vực/ nhóm"
                    @change="itemCode"
                    clearable
                ></v-select>
            </v-flex>
            
        </v-layout>
        <div id="list-content">
            <v-layout wrap class="header-menu" >
                <div style="width:5%"><b>STT</b></div>
                <div style="width:30%"><b>Nội dung</b></div>
                <div style="width:20%"><b>Đơn vị chủ trì</b></div>
                <div style="width:13%"><b>Hạn hoàn thành</b></div>
                <div style="width:12%"><b>Trạng thái</b></div>
                <div style="width:20%"><b>Ghi chú</b></div>
            </v-layout>
            <div v-for="item in mainItems" :key="item.leader.employeeId">
                <v-expansion-panel expand>
                    <v-expansion-panel-content v-bind:value="item === 1">
                        <div slot="header" class="custome-panel-heading-with-icon mr-2 pl-0">
                            <b>{{item.leader.title}} {{ item.leader.fullName }} - {{ item.leader.jobTitle }}</b>
                        </div>
                        
                        <v-card class="">
                            <v-card-text class="px-0 py-0">
                                <v-layout row wrap class="mx-0">
                                <v-flex xs12 sm12>
                                        <v-card>
                                            <v-list class="py-0">
                                                <v-list-group class="py-0" v-for="item1 in item.activityItems" :value="item1.active" v-bind:key="item1.activityId">
                                                        <v-list-tile slot="item" class="px-0">
                                                            <v-list-tile-content class="px-0 pl-2">
                                                                <v-flex xs12 class="layout wrap">
                                                                    <v-list-tile-title class="item_group">
                                                                        <b style="font-family: sans-serif">{{ parseDateView(new Date(item1.startDate))}}</b> - {{item1.resultNote}}
                                                                    </v-list-tile-title>
                                                                    
                                                                </v-flex>
                                                                
                                                            </v-list-tile-content>
                                                        </v-list-tile>
                                                        
                                                        <!-- end -->
                                                        <v-list-tile-content class="mt-2">
                                                            <v-data-table id="subTableActivity"
                                                            hide-headers
                                                            :items="item.activitySourceItems"
                                                            item-key="activityId"
                                                            hide-actions
                                                            >
                                                                <template slot="items" scope="props">
                                                                    
                                                                    <tr v-bind:class="{'active': props.index%2==1}">
                                                                        <td class="text-xs-center py-2" style="width: 5%">{{props.index}}</td>
                                                                        <td class="text-xs-center py-2" style="width: 30%">{{ props.item.subject }}</td>
                                                                        <td class="text-xs-center py-2" style="width: 20%">{{ props.item.hosting }}</td>
                                                                        <td class="text-xs-center py-2" style="width: 13%">{{parseDateView(new Date(props.item.endDate))}}</td>
                                                                        <td class="text-xs-center" style="width: 12%">
                                                                            <v-chip style="display: inline-block;text-align: center;width:90%" label outline :color="getColor(props.item.stateName)">
                                                                                <span>{{getState(props.item.stateName)}}</span>
                                                                            </v-chip>
                                                                            
                                                                        </td>
                                                                        <td class="text-xs-center py-2" style="width: 20%">{{ props.item.resultNote }}</td>
                                                                    </tr>
                                                                    
                                                                </template>
                                                            </v-data-table>
                                                            
                                                        </v-list-tile-content>  
                                                    
                                                        <!-- end -->
                                                </v-list-group>
                                                
                                            </v-list>
                                        </v-card>
                                    </v-flex>
                                </v-layout>
                            </v-card-text>
                        </v-card>
                    </v-expansion-panel-content>
                </v-expansion-panel>
                <v-divider xs12 class="my-0"></v-divider>
                <!--  -->
            </div>
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
                vm.getActivityCat();
                setTimeout(function(){
                    vm.getActivity()
                },1000)
                
            })
        },
        
        data () {
            return {
                class_name: "org.mobilink.activitymgt.model.Activity",
                mainItems: [
                    
                ],
                
                userId: '',
                activityListItems:[],
                radioGroup:'leader',
                managerItems: [],
                manager:'',
                activityCatItems:[],
                activityCat:'',
                timeStart:'',
                timeEnd:'',
                timeEndMin:'',
                timeStartMax:'',
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
            getActivityCat: function(){
                var vm = this;
                var paramsTypeProcess = {
                    sort: "treeIndex"
                };
                const configTypeProcess = {
                    params: paramsTypeProcess,
                    headers: {
                        'groupId': vm.group_id
                    }

                };
                /* Load data loại hoạt động*/
                axios.get( vm.end_point + 'dictcollections/ACTIVITY_TYPE/dictitems', configTypeProcess)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            if (serializable.data[key].level === 1) {
                                vm.activityCatItems.push({
                                    itemName: serializable.data[key].itemName,
                                    itemCode: serializable.data[key].itemCode
                                })
                            }                            
                        }
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
                            vm.getListItemGroup(vm.activityCatItems);
                            vm.getListActivityItemsGroup(vm.activityCatItems);
                            vm.getListActivitySource(vm.mainItems[0].activityItems[0].activityId,0)
                        } else if(vm.radioGroup=='leader') {
                            vm.getListItemGroup(vm.managerItems);
                            vm.getListActivityItemsGroup(vm.activityCatItems);
                            vm.getListActivitySource(vm.mainItems[0].activityItems[0].activityId,0)
                        };
                        
                    }else {
                        
                    }
                    console.log(vm)
                })
                .catch(function (error) {
                    console.log(error);
                    
                });
            },
            callGetActivity: function(){
                var vm = this;
                vm.activityListItems=[];
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
                        if(vm.radioGroup=='activityCat'){
                            vm.getListItemGroup(vm.activityCatItems);
                            vm.getListActivityItemsGroup(vm.activityCatItems);
                            vm.getListActivitySource(vm.mainItems[0].activityItems[0].activityId,0)
                        } else if(vm.radioGroup=='leader') {
                            vm.getListItemGroup(vm.managerItems);
                            vm.getListActivityItemsGroup(vm.activityCatItems);
                            vm.getListActivitySource(vm.mainItems[0].activityItems[0].activityId,0)
                        };
                        
                    }else {
                        
                    }
                    console.log(vm)
                })
                .catch(function (error) {
                    console.log(error);
                    
                });
            },
            /**Lọc theo leader */
            changeGroup: function(){
                var vm = this;
                vm.timeStart = '';
                vm.timeEnd= '';
                vm.activityCat = '';
                vm.manager = '';
                vm.getActivity()
            },
            changeDate: function(){
                var vm = this;
                setTimeout(function(){
                    vm.timeEndMin = vm.timeStart?new Date(vm.timeStart):null;
                    vm.timeStartMax = vm.timeEnd?new Date(vm.timeEnd):null;
                    vm.paramsGet.fromdate = vm.timeStart?vm.parseDateFormat(vm.timeStart):null;
                    vm.paramsGet.todate = vm.timeEnd?vm.parseDateFormat(vm.timeEnd):null;
                    vm.callGetActivity()
                },200)
                
            },
            /**Lọc theo leader */
            getFilterLeader: function(){
                var vm = this;
                setTimeout(function(){
                    vm.paramsGet.leader  = vm.manager.employeeId;
                    vm.callGetActivity();
                },200)
            },
            /**Lọc theo activityCat */
            getFilterActivityCat: function(){
                var vm = this;
                setTimeout(function(){
                    vm.paramsGet.category  = vm.activityCat.itemCode;
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
                            if(target[key].itemCode == vm.activityListItems[index].activityCat){
                                vm.mainItems.push(
                                    {
                                        'leader': target[key],
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
                                        'leader': target[key],
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
                        if(vm.radioGroup == "activityCat"&&vm.mainItems.length!=0){
                            if(vm.activityListItems[index].activityCat == vm.mainItems[key].leader.itemCode){
                                vm.mainItems[key].activityItems.push(vm.activityListItems[index]);
                            }
                        } else if(vm.radioGroup == "leader"&&vm.mainItems.length!=0){
                            if(vm.activityListItems[index].leaderId == vm.mainItems[key].leader.mappingUser.userId){
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
                axios.get( vm.end_point + 'activities/source/'+vm.class_name+'/'+ class_pk, configGetSource)
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
                if(radio=="activityCat"){
                    return 'itemCode'
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
            parseDateFormat : function(fullDate){
                var date;
                if(fullDate){
                    date = fullDate.getFullYear()+(fullDate.getMonth()+1).toString().padStart(2, '0')+fullDate.getDate().toString().padStart(2, '0');
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
    #activity_manager .header-menu{
        background-color: #82dad5!important;
        height: 40px;
    }
    #activity_manager .header-menu div{
        text-align: center;
        overflow: hidden;
        text-overflow: ellipsis; 
        white-space: nowrap;
        border: 1px solid #ddd !important;
        padding: 8px 5px!important;
    }
    #activity_manager #list-content table tr td{
        overflow: hidden;
        text-overflow: ellipsis; 
        white-space: nowrap;
        border: 1px solid #ddd !important;
        padding: 8px 5px!important;
    }
    #activity_manager #list-content .list--group__container{
        border: 1px solid #ddd !important;
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

