<template>

    <div id="activity_manager">
        <v-layout wrap class="navTable px-3 py-3">
            <v-flex xs2 sm2>
                <v-subheader class="px-0">Nhóm theo: </v-subheader>
            </v-flex>
            <v-flex xs10 sm10 class="pt-2">
                <v-radio-group v-model="radioGroup" @change="getActivity" row class="py-0 groupRadido">
                    <v-radio class="my-0" label="Nguồn" color="secondary"
                        value="source">
                    </v-radio>
                    <v-radio class="my-0" label="Lãnh đạo" color="secondary"
                        value="leader">
                    </v-radio>
                    <v-radio class="my-0" label="Đơn vị chủ trì" color="secondary"
                        value="workingUnit">
                    </v-radio>
                </v-radio-group>
            </v-flex>
            <v-flex xs12 sm2 class="mt-2">
                <v-subheader class="px-0">Từ ngày: </v-subheader>
            </v-flex>
            <v-flex xs12 sm4 class="pr-3">
                <date-picker class="mt-3" v-model="timeStart" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
            </v-flex>
            <v-flex xs12 sm2 class="mt-2">
                <v-subheader class="px-0">Đến ngày: </v-subheader>
            </v-flex>
            <v-flex xs12 sm4>
                <date-picker class="mt-3" v-model="timeEnd" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
            </v-flex>
            <v-flex xs12 sm2 class="mt-2">
                <v-subheader class="px-0">Lọc theo lãnh đạo: </v-subheader>
            </v-flex>
            <v-flex xs12 sm4 class="pt-3 pr-3">
                <v-select class="selectBoder py-0"
                    v-bind:items="managerItems"
                    v-model="manager"
                    return-object
                    clearable
                    item-text="fullName"
                    item-value="employeeId"
                    autocomplete
                    placeholder="Chọn lãnh đạo"
                    
                ></v-select>
            </v-flex>
            <v-flex xs12 sm2 class="mt-2">
                <v-subheader class="px-0">Lọc theo đơn vị chủ trì: </v-subheader>
            </v-flex>
            <v-flex xs12 sm4 class="pt-3">
                <v-select class="selectBoder py-0"
                    v-bind:items="hostingIdItems"
                    v-model="hostingId"
                    item-text="name"
                    item-value="workingUnitId"
                    return-object
                    autocomplete
                    placeholder="Chọn đơn vị"
                    
                    clearable
                ></v-select>
            </v-flex>

            
        </v-layout>


        <!-- TABLE -->
        <v-slide-x-transition>

            <v-data-table id="tableActivity" 
            :headers="mainHeaders"
            :items="mainItems"
            item-key="workingUnitId"
            hide-actions
            expand
            >
                <template slot="items" scope="props">
                    <tr @click="props.expanded = !props.expanded" v-bind:class="{'active': props.index%2==1}">
                        <td colspan="100%" class="px-0">
                            <v-card class="pl-3">
                                <v-card-text v-if="radioGroup=='workingUnit'">
                                    {{ props.item.name }}
                                </v-card-text>
                                <v-card-text v-if="radioGroup=='leader'">
                                    Đồng chí {{ props.item.fullName }} - {{ props.item.jobTitle }}
                                </v-card-text>
                            </v-card>
                        </td>
                        
                    </tr>
                  
                </template>

                <template slot="expand" scope="props">
                        <v-data-table id="subTableActivity"
                        hide-headers
                        :items="subItems[props.index]"
                        item-key="activityId"
                        hide-actions
                        >
                            <template slot="items" scope="props">
                                
                                <tr v-bind:class="{'active': props.index%2==1}">
                                    <td class="text-xs-center py-2">{{props.index}}</td>
                                    <td class="text-xs-center py-2">{{ props.item.subject }}</td>
                                    <td class="text-xs-center py-2">{{ props.item.hosting }}</td>
                                    <td class="text-xs-center py-2">{{ props.item.endDate }}</td>
                                    <td class="text-xs-center py-2">{{ props.item.stateName }}</td>
                                    <td class="text-xs-center py-2">{{ props.item.resultNote }}</td>
                                </tr>
                                
                            </template>
                        </v-data-table>
                    
                </template>
            </v-data-table>

        </v-slide-x-transition>

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
                userId: '',
                activityListItems:[],
                radioGroup:'workingUnit',
                managerItems: [],
                manager:'',
                hostingIdItems:[],
                hostingId:'',
                timeStart:'',
                timeEnd:'',
                mainItems: [],
                subItems: [],

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
                    type:'TASK'
                };
                var configGetActivity = {
                    params: paramsGetActivity,
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
                            vm.getListSubitemGroup()
                        } else if(vm.radioGroup=='leader') {
                            vm.getListItemGroup(vm.managerItems);
                            vm.getListSubitemGroup()
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
            /**get list item group */
            getListItemGroup: function(target){
                var vm = this;
                vm.mainItems =[];
                vm.subItems =[];
                for(var key in target) {
                    for(var index in vm.activityListItems){
                        if(vm.radioGroup == "workingUnit"){
                            if(target[key].workingUnitId == vm.activityListItems[index].hostingId){
                                vm.mainItems.push(target[key]);
                                vm.subItems.push([]);
                                break;
                            }
                        } else if(vm.radioGroup == "leader"){
                            if(target[key].mappingUser.userId == vm.activityListItems[index].leaderId){
                                vm.mainItems.push(target[key]);
                                vm.subItems.push([]);
                                break;
                            }
                            
                        }
                        
                        
                    }
                }
            },
            getListSubitemGroup: function(){
                var vm =this;
                for(var key in vm.mainItems) {
                    for(var index in vm.activityListItems){
                        if(vm.radioGroup == "workingUnit"&&vm.mainItems.length!=0){
                            if(vm.activityListItems[index].hostingId == vm.mainItems[key].workingUnitId){
                                vm.subItems[key].push(vm.activityListItems[index]);
                            }
                        } else if(vm.radioGroup == "leader"&&vm.mainItems.length!=0){
                            if(vm.activityListItems[index].leaderId == vm.mainItems[key].mappingUser.userId){
                                vm.subItems[key].push(vm.activityListItems[index]);
                            }
                        }
                        
                        
                    }
                }
            }
        }

    }
</script>

<style>
    #activity_manager .navTable{
        background-color: #96c1ec!important;
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
    #activity_manager .navTable  .input-group--select__autocomplete{
        color: #555!important;
        font-size: 14px!important;
    }
    #activity_manager .mx-datepicker{
        width: 100%!important
    }
    #activity_manager .menu .menu__content--select {
        top: 220px!important;
    }
    #activity_manager #tableActivity thead {
        background-color: #82dad5!important
    }
    #activity_manager #subTableActivity tr{
        height: 40px!important
    }
    #activity_manager #tableActivity table thead tr th{
        border: 1px solid #ddd !important;

    }
    #activity_manager #tableActivity table tbody td {
        border: 1px solid #ddd !important;
    }
    #activity_manager .groupRadido .radio{
        max-width: 150px !important;
    }
    #activity_manager .groupRadido .radio label{
        padding-left: 0!important
    }
    #activity_manager  .radio-group--row{
        padding-top: 0!important
    }
    #activity_manager #tableActivity td .card__text{
        font-weight: bold !important;
        padding-left: 8px !important
    }
</style>

