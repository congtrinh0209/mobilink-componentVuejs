<template>

    <div id="activity_eventsource">
        
        <div style="position: relative; overflow: hidden;">

            <v-expansion-panel expand class="sub-panel">
                <v-expansion-panel-content value="true">
                    <div slot="header" class="custome-panel-heading-with-icon pl-0 mr-2">
                        <div class="">Cuộc họp liên quan</div>

                        <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_add_link" 
                        v-if="managerPermision(permission_prop)" grey darken-4>
                            add_circle
                        </v-icon>
                        <!-- <div class="menu" style="display: inline-block;">
                            <div class="menu__activator">
                                <v-btn icon slot="activator" @click.native="fileVersionDialog = false">
                                    <v-icon>close</v-icon>
                                </v-btn>
                            </div>
                        </div> -->
                    </div>
                    
                    <v-card>
                        <v-card-text class="px-0 py-0 pl-2 pr-1">
                            <v-layout row wrap class="mx-0">
                                <!-- Phần dialog -->
                                <v-dialog v-model="dialog_add_eventlink" scrollable persistent min-width="700px" max-width="700px">
                                    <v-card>
                                        <v-card-title class="py-0" style="background-color: rgb(214, 233, 247)">
                                            <span>Cập nhật cuộc họp liên quan</span>
                                            <v-spacer></v-spacer>
                                            
                                            <div class="menu" style="display: inline-block;">
                                                <div class="menu__activator">
                                                    <v-btn class="px-0" icon slot="activator" @click.native="dialog_add_eventlink= false">
                                                        <v-icon>clear</v-icon>
                                                    </v-btn>
                                                </div>
                                            </div>
                                        </v-card-title>

                                        <v-card-text class="dialog_eventlink">
                                            <v-layout wrap >
                                                <div style="width:14%">
                                                    <v-subheader class="px-0">Ngày bắt đầu: </v-subheader>
                                                </div>
                                                <div class="mr-2" style="width:22%">
                                                    <date-picker @change="changeDate" class="mt-2" v-model="timeStart" placeholder="Từ ngày"
                                                    v-bind:not-after="timeStartMax" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
                                                </div>

                                                <div class="mr-2" style="width:22%">
                                                    <date-picker @change="changeDate" class="mt-2" v-model="timeEnd" placeholder="Đến ngày"
                                                    v-bind:not-before="timeEndMin" lang="vi" type="date" format="dd/MM/yyyy"></date-picker>
                                                </div>
                                                <div class="ml-1" style="width:8%">
                                                    <v-subheader class="px-0">Chủ trì: </v-subheader>
                                                </div>
                                                <div class="mt-2" style="width:30%">
                                                    <v-select class="selectBoder py-0"
                                                        v-bind:items="managerItems"
                                                        v-model="manager"
                                                        return-object
                                                        clearable
                                                        item-text="fullName"
                                                        item-value="employeeId"
                                                        autocomplete
                                                        placeholder="Chọn lãnh đạo chủ trì"
                                                        hide-selected
                                                        @change="getFilterLeader"
                                                    >
                                                        <template slot="item" slot-scope="data">
                                                            <template>
                                                                <v-list-tile-content>
                                                                    <v-list-tile-title v-html="data.item.fullName"></v-list-tile-title>
                                                                    <v-list-tile-sub-title v-html="data.item.email"></v-list-tile-sub-title>
                                                                </v-list-tile-content>
                                                            </template>
                                                        </template>
                                                    </v-select>
                                                </div>
                                                <v-flex xs12 sm10 class="mt-2">
                                                    <v-text-field class="pt-0" id="searchInput"
                                                        placeholder="Tên cuộc họp"
                                                        single-line
                                                        hide-details
                                                        v-model="keySearch"
                                                    ></v-text-field>
                                                </v-flex>
                                                <v-flex xs12 sm2>
                                                    <v-btn v-on:click.native="keywordSearch" class="px-0 primary" style="height: 30px">
                                                        Tìm kiếm
                                                    </v-btn>
                                                </v-flex>
                                                <!--  -->
                                                <v-flex xs12 sm12 class="mt-3">
                                                    <v-list class="py-0">
                                                        <v-list-tile v-for="(item,index) in itemActivityEvent" v-bind:key="item.activityId" class="px-0">
                                                            <v-list-tile-content>
                                                                <v-list-tile-title>
                                                                    <v-flex xs12 class="layout wrap">

                                                                        <v-flex xs2 sm1 style="text-align: center">
                                                                            <v-btn small outline color="blue-grey" class="px-0 mx-0 primary" style="height: 30px;min-width:0px"
                                                                             @click.stop="selectEventLink(item, index)"
                                                                            >
                                                                                Chọn
                                                                            </v-btn>
                                                                        </v-flex>

                                                                        <v-flex xs6 sm5 class="pl-3 mt-2 overFlow">
                                                                            <span :title="item.subject"> {{item.subject}} </span>
                                                                        </v-flex>
                                                                        
                                                                        <v-flex xs3 sm4 class="pl-2 mt-2 overFlow">
                                                                            <span :title="item.leaderName">Chủ trì: {{item.leaderName}}</span>
                                                                        </v-flex>
                                                                        
                                                                        <v-flex xs3 sm2 style="text-align: center" class="mt-2">
                                                                            <span title="Ngày bắt đầu">{{ parseDateView(new Date(item.startDate))}}</span>
                                                                        </v-flex>

                                                                    </v-flex>
                                                                </v-list-tile-title>

                                                            </v-list-tile-content>

                                                        </v-list-tile>
                                                    </v-list>
                                                    <p v-if="itemActivityEvent.length == 0" class="mt-3 ml-2">Không có cuộc họp</p>
                                                </v-flex>

                                            </v-layout>
                                        </v-card-text>

                                    </v-card>
                                </v-dialog>
                                <!-- end -->

                                <v-flex xs12 sm12>
                                    <v-card>
                                        <v-list class="py-0">
                                            <v-list-group class="listGroup py-0" v-for="(item,index) in itemEventLink" 
                                             v-bind:key="item.eventItem.activityId">                                            
                                                <v-list-tile slot="item" class="px-0">
                                                    <v-list-tile-content>
                                                        <v-list-tile-title>
                                                            <v-flex xs12 class="layout wrap">

                                                                <v-flex xs6 sm6 class="pr-2 subEl">
                                                                    
                                                                    <a href="javascript:;" :title="item.eventItem.subject" v-on:click.stop="activityDetail(item.eventItem,index)">
                                                                        {{item.eventItem.subject}}
                                                                    </a>
                                                                </v-flex>
                                                                
                                                                <v-flex xs3 sm3 class="pl-2">
                                                                    <span>Chủ trì: {{item.eventItem.leaderName}}</span>
                                                                </v-flex>
                                                                
                                                                <v-flex xs3 sm2 style="text-align: center">
                                                                    <span>{{ parseDateView(new Date(item.eventItem.startDate))}}</span>
                                                                </v-flex>

                                                                <v-flex xs3 sm1 style="text-align: center">
                                                                    <v-icon color="red darken-3" title="Xóa" class="delete_icon"
                                                                    v-if="managerPermision(permission_prop)" icon 
                                                                    @click.stop="deleteActivity(item.eventItem,index,itemEventLink)">clear</v-icon>
                                                                </v-flex>
                                                            </v-flex>
                                                        </v-list-tile-title>

                                                    </v-list-tile-content>

                                                    <v-list-tile-action style="flex-direction: row;min-width: 0px!important"
                                                    title="Xem kết luận cuộc họp" @click="getListActivitySource(item.eventItem.activityId,index)"
                                                    >
                                                        <v-btn icon>
                                                            <v-icon>keyboard_arrow_down</v-icon>
                                                        </v-btn>
                                                    </v-list-tile-action>
                                                </v-list-tile>

                                                <!-- end -->
                                                <v-list-tile-content>
                                                    <v-data-table id="subTableActivity"
                                                    hide-headers
                                                    no-data-text="Không có kết luận"
                                                    :items="item.activitySourceItems"
                                                    item-key="activityId"
                                                    hide-actions
                                                    >
                                                        <template slot="items" scope="props">
                                                            
                                                            <tr v-bind:class="{'active': props.index%2==1}">
                                                                <td class="text-xs-center py-3" style="width: 5%">{{props.index + 1}}</td>
                                                                <td class="py-3" style="width: 35%" :title="props.item.subject">
                                                                    <a href="javascript:;" v-on:click.stop="activityDetail(props.item,props.index)">
                                                                        <span>{{ props.item.subject }}</span>
                                                                    </a>
                                                                    
                                                                </td>
                                                                <td class="py-3" style="width: 28%" :title="props.item.hosting ">{{ props.item.hosting }}</td>
                                                                <td class="text-xs-center py-3" style="width: 15%">{{parseDateView(new Date(props.item.endDate))}}</td>
                                                                <td class="text-xs-center" style="width: 17%">
                                                                    <v-chip style="display: inline-block;text-align: center;width:80%" label outline :color="getColor(props.item.state)">
                                                                        <span>{{props.item.stateName}}</span>
                                                                    </v-chip>
                                                                    
                                                                </td>
                                                                
                                                            </tr>
                                                            
                                                        </template>
                                                    </v-data-table>
                                                    
                                                </v-list-tile-content>
                                            </v-list-group>
                                        </v-list>
                                        <p v-if="itemEventLink.length == 0" class="mt-3 ml-2">Không có cuộc họp liên quan</p>
                                    </v-card>
                                </v-flex>
                            </v-layout>
                        </v-card-text>
                    </v-card>
                </v-expansion-panel-content>
            </v-expansion-panel>

        </div>
    </div>
</template>


<script>
    const COMPONENT_NAME = 'jx-mobilink-activity-eventsource'

    export default {
        name: COMPONENT_NAME,
        props: {
            class_pk: null,
            class_name: null,
            group_id: null,
            end_point: null,
            permission_prop: null,
            startend_prop:null
        },

        created () {
            var vm = this
            vm.$nextTick(function () {
                vm.initEventLink()
            })
        },
        data () {
            return {
                itemActivityEvent: [],
                itemEventLink: [],
                managerItems: [],
                manager:'',
                keySearch:'',
                timeStart: '',
                timeEnd: '',
                timeStartMax:'',
                timeEndMin:'',
                paramsGet: {},
                dialog_add_eventlink: false
            }
        },
        
        methods: {
            initEventLink: function(){
                var vm = this;
                console.log(vm._props);
                vm.getActivityLink()
            },
            show_add_link: function(){
                var vm = this;
                vm.dialog_add_eventlink = true;
                var date = new Date();
                vm.timeStart = new Date(date.getFullYear(), date.getMonth(), 1);
                vm.timeEnd = new Date(date.getFullYear(), date.getMonth() + 1, 0);
                vm.paramsGet = {
                    sort:'startDate_Number',
                    type: 'EVENT',
                    fromdate: vm.timeStart?vm.parseDateFormat(vm.timeStart):null,
                    todate: vm.timeEnd?vm.parseDateFormat(vm.timeEnd):null
                };
                vm.getActivity(vm.paramsGet);
                vm.getUsers();
            },
            selectEventLink: function(item,index){
                var vm = this;
                var paramsAddEventLink = new URLSearchParams();
                paramsAddEventLink.append('targetId', item.activityId);

                var configAddActivityLink = {
                    headers: {
                        groupId: vm.group_id
                    }
                };
                var url = vm.end_point + 'activities/' + vm.class_pk + '/links';
                axios.post(url, paramsAddEventLink, configAddActivityLink)
                .then(function (response) {
                    vm.itemActivityEvent.splice(index, 1);
                    showMessageToastr('success', 'Cập nhật thành công');
                    vm.getActivityLink()
                })
                .catch(function (error) {
                    showMessageByAPICode(error.response.status, error.response.data);
                    console.log(error.response)               
                });
                
            },
            /**Load activity detail */
            activityDetail: function(item, index){
                this.$emit('view_detail', item, index);
            },
            /**delete activity */
            deleteActivity: function (item, index, items) {
                this.$emit('delete_activity', item, index, items);
            },
            
            /* Load data activity */
            getActivity: function(param){
                /*console.log("run get getActivity");*/
                var vm = this;
                vm.itemActivityEvent=[];
                var configGetActivity = {
                    params: param,
                    headers: {
                        groupId: vm.group_id
                    }
                };
                var url = vm.end_point + 'activities';
                axios.get(url, configGetActivity).then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            if (vm.itemEventLink.length!=0){
                                var itemInv = true;
                                for (var keys in vm.itemEventLink){
                                    if (serializable.data[key].activityId == vm.itemEventLink[keys].eventItem.activityId||
                                        serializable.data[key].activityId == vm.class_pk
                                    ){
                                        itemInv = false;
                                        break;
                                    }
                                }
                                if (itemInv){
                                    vm.itemActivityEvent.push(serializable.data[key]);
                                }
                            } else {
                                if (serializable.data[key].activityId != vm.class_pk){
                                    vm.itemActivityEvent.push(serializable.data[key])
                                }
                            }
                            
                        };
                        
                    } else {
                        
                    }
                    console.log(vm)
                })
                .catch(function (error) {
                    console.log(error);
                    
                });
            },
            // 
            changeDate: function(){
                var vm = this;
                vm.keySearch = '';
                setTimeout(function(){
                    vm.timeEndMin = vm.timeStart?new Date(vm.timeStart):'';
                    vm.timeStartMax = vm.timeEnd?new Date(vm.timeEnd):'';
                    vm.paramsGet = {
                        sort:'startDate_Number',
                        type: 'EVENT',
                        fromdate: vm.timeStart?vm.parseDateFormat(vm.timeStart):null,
                        todate: vm.timeEnd?vm.parseDateFormat(vm.timeEnd):null,
                        leader: vm.manager?vm.manager.employeeId:null
                    };
                    vm.getActivity(vm.paramsGet);
                },200)
                
            },
            /**Lọc theo leader */
            getFilterLeader: function(){
                var vm = this;
                vm.keySearch = '';
                setTimeout(function(){
                    vm.paramsGet = {
                        sort:'startDate_Number',
                        type: 'EVENT',
                        fromdate: vm.timeStart?vm.parseDateFormat(vm.timeStart):null,
                        todate: vm.timeEnd?vm.parseDateFormat(vm.timeEnd):null,
                        leader: vm.manager?vm.manager.employeeId:null
                    };
                    vm.getActivity(vm.paramsGet);
                },200)
            },
            // 
            keywordSearch: function(){
                var vm = this;
                vm.timeStart = '';
                vm.timeEnd = '';
                vm.manager = '';
                vm.paramsGet = {
                    sort:'startDate_Number',
                    type: 'EVENT',
                    keywords: vm.keySearch
                };
                vm.getActivity(vm.paramsGet);
            },
            // 
            getActivityLink: function(){
                /*console.log("run get getActivity");*/
                var vm = this;

                var paramsGetActivityLink = {
                    sort:'startDate_Number'
                    
                };
                vm.paramsGet = paramsGetActivityLink;
                var configGetActivityLink = {
                    params: vm.paramsGet,
                    headers: {
                        groupId: vm.group_id
                    }
                };
                var url = vm.end_point + 'activities/' + vm.class_pk + '/links';
                axios.get(url, configGetActivityLink).then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            vm.itemEventLink.push({
                                eventItem: serializable.data[key],
                                activitySourceItems:[]
                            })

                        };
                                                
                    }
                    console.log(vm)
                })
                .catch(function (error) {
                    console.log(error);
                    
                });
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
                if(vm.itemEventLink[index].activitySourceItems.length==0){
                    axios.get( vm.end_point + 'activities/source/'+vm.class_name+'/'+ class_pk, configGetSource)
                    .then(function (response) {
                        var serializable = response.data
                        if (serializable.hasOwnProperty('data')) {
                            for (var key in serializable.data) {
                                vm.itemEventLink[index].activitySourceItems.push(
                                    serializable.data[key]
                                )
                            
                            }
                        }
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
                }
                
            },
            /**get users */
            getUsers: function(){
                var vm = this;
                var paramsEmployees = {
                    'class': 'employee',
                };
                const configEmployees = {
                    params: paramsEmployees,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'users', configEmployees)
                    .then(function (response) {
                        var serializable = response.data;
                        if (serializable.hasOwnProperty('data')) {
                            for (var key in serializable.data) {
                                vm.managerItems.push({
                                    fullName: serializable.data[key].fullName,
                                    employeeId: serializable.data[key].userId,
                                    email: serializable.data[key].email
                                })
                                
                            }
                        }
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
            },
            /**Check permision */
            managerPermision: function(permision){
                if(permision=='manager'||permision=='hoster'||permision=='owner'||permision=='leader'){
                    return true
                } else {return false}
            },
            /**parse date */
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
        }

    }
</script>

<style>
    .subEl, .overFlow {
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    .subEl a:hover{
        color: #1a5eba!important;
    }
    #activity_eventsource .card li {
        border-bottom: 1px dashed #ddd;
    }
    #activity_eventsource .delete_icon:hover{
        cursor: pointer;
    }
    #activity_eventsource table tr td{
        overflow: hidden;
        text-overflow: ellipsis; 
        white-space: nowrap;
        padding-left: 5px!important;
        padding-right: 5px!important;
    }
    #activity_eventsource table{
        table-layout: fixed;
        margin-bottom: 0px
    }
    #activity_eventsource table .chip__content{
        padding: 0px!important
    }
    #activity_eventsource .dialog_eventlink .mx-datepicker{
        width: 100%!important
    }
    #activity_eventsource table a:hover{
        color: #1a5eba!important;
    }
    .dialog_eventlink{
        min-height: 300px
    }
    .dialog_eventlink .input-group--text-field .input-group__input{
        padding-left: 3px
    }
    .dialog_eventlink .input-group .input-group__input{
        border: 1px solid #ddd;
        margin-top: 0px!important;
        border-radius: 2px!important;
    }
    .dialog_eventlink .input-group .input-group__details{
        display: none
    }
    .dialog_eventlink .mx-datepicker{
        width: 100%!important;
        min-width: 0px!important;
    }
    .dialog_eventlink .input-group--select .input-group__input{
        border: 1px solid #ddd;
        border-radius: 2px!important;
    }
    .dialog_eventlink .input-group--select .input-group__details{
        display: none
    }
    .dialog_eventlink ul li {
        border-bottom: 1px dashed #ddd;
    }
    .dialog_eventlink ul li .list__tile{
        padding-left: 0px;
        padding-right: 0px
    }
    .dialog_eventlink .list__tile__title, .dialog_eventlink .list__tile{
        height: 100%;
    }
</style>

