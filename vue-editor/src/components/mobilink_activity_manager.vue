<template>

    <div id="activity_manager">
        <v-layout wrap class="navTable px-3 py-1 pb-2">
            <v-flex xs2 sm1>
                <v-subheader class="px-0">Nhóm theo: </v-subheader>
            </v-flex>
            <v-flex xs10 sm11 class="pt-2 pl-4">
                <v-radio-group v-model="radioGroup" @change="changeGroup" row class="py-0 groupRadido">
                    <v-radio class="my-0" label="Lãnh đạo" color="secondary"
                        value="leader">
                    </v-radio>
                   
                    <v-radio class="my-0" label="Lĩnh vực/ nhóm" color="secondary"
                        value="activityCat">
                    </v-radio>
                </v-radio-group>
            </v-flex>

            <v-flex xs12 sm1 class="mt-2">
                <v-subheader class="px-0">Từ ngày: </v-subheader>
            </v-flex>
            <v-flex xs12 sm3 class="mr-3 pl-4">
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
                <div style="width:5%"><p>STT</p></div>
                <div style="width:30%"><p>Nội dung</p></div>
                <div style="width:20%"><p>Đơn vị chủ trì</p></div>
                <div style="width:12%"><p>Hạn hoàn thành</p></div>
                <div style="width:13%"><p>Trạng thái</p></div>
                <div style="width:20%"><p>Ghi chú</p></div>
            </v-layout>
            
            <v-expansion-panel expand class="expansion-blue" v-for="(item,index) in mainItems" :key="item.leader.employeeId">
                <v-expansion-panel-content :value="item==mainItems[0]">
                    <div slot="header"  @click="getListActivitySource(item.activityItems[0].activityId,index,0)" 
                    class="custome-panel-heading-with-icon groupHeader mr-2 pl-0" style="width: 90%;font-family: sans-serif">
                        <p v-if="radioGroup == 'leader'" :title="item.leader.title + item.leader.fullName + '-' + item.leader.jobTitle" class="my-0">
                            {{item.leader.title}} {{ item.leader.fullName }} - {{ item.leader.jobTitle }}
                        </p>
                        <p v-if="radioGroup == 'activityCat'" :title="item.leader.itemName" class="my-0">{{item.leader.itemName}}</p>
                    </div>
                    
                    <v-card class="">
                        <v-card-text class="px-0 py-0">
                            <v-layout row wrap class="mx-0">
                            <v-flex xs12 sm12>
                                    <v-card>
                                        <v-list class="py-0">
                                            <v-list-group class="listGroup py-0" v-for="(item1,index1) in item.activityItems" 
                                            :value="item1.activityId==item.activityItems[0].activityId" v-bind:key="item1.activityId">
                                                <v-list-tile slot="item" class="px-0">
                                                    <v-list-tile-content class="px-0 pl-2">
                                                        <v-list-tile-title class="item_group">
                                                            <p :title="item1.subject" class="icon_view py-0" @click.stop="activityDetail(item1,index1)">
                                                                <b>{{ parseDateView(new Date(item1.startDate))}}</b> - {{item1.subject}}
                                                            </p>
                                                            
                                                        </v-list-tile-title>
                                                    </v-list-tile-content>

                                                    <v-list-tile-action class="pr-2" style="flex-direction: row"
                                                    title="Xem kết luận cuộc họp" @click="getListActivitySource(item1.activityId,index,index1)"
                                                    >
                                                        <v-icon >keyboard_arrow_down</v-icon>
                                                    </v-list-tile-action>
                                                </v-list-tile>
                                                
                                                <!-- end -->
                                                <v-list-tile-content>
                                                    <v-data-table id="subTableActivity"
                                                    hide-headers
                                                    no-data-text="Không có kết luận"
                                                    :items="item.activitySourceItems[index1]"
                                                    item-key="activityId"
                                                    hide-actions
                                                    >
                                                        <template slot="items" scope="props">
                                                            
                                                            <tr v-bind:class="{'active': props.index%2==1}">
                                                                <td class="text-xs-center py-2" style="width: 5%">{{props.index + 1}}</td>
                                                                <td class="py-2" style="width: 30%" :title="props.item.subject">
                                                                    <a href="javascript:;" v-on:click.stop="activityDetail(props.item,props.index)">
                                                                        <span>{{ props.item.subject }}</span>
                                                                    </a>
                                                                    
                                                                </td>
                                                                <td class="py-2" style="width: 20%" :title="props.item.hosting ">{{ props.item.hosting }}</td>
                                                                <td class="text-xs-center py-2" style="width: 12%">{{parseDateView(new Date(props.item.endDate))}}</td>
                                                                <td class="text-xs-center" style="width: 13%">
                                                                    <v-chip style="display: inline-block;text-align: center;width:90%" label outline :color="getColor(props.item.state)">
                                                                        <span>{{props.item.stateName}}</span>
                                                                    </v-chip>
                                                                    
                                                                </td>
                                                                <td class="py-2" style="width: 20%" :title="props.item.resultNote">{{ props.item.resultNote }}</td>
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
                    <v-divider xs12 class="my-0"></v-divider>
                </v-expansion-panel-content>
                <v-divider xs12 class="my-0"></v-divider>
            </v-expansion-panel>
            
        </div>
        
    </div>
</template>


<script>
    const COMPONENT_NAME = 'jx-mobilink-activity-manager'

    export default {
        name: COMPONENT_NAME,

        created () {
            var vm = this;
            vm.$nextTick(function () {

                Promise.all([vm.getManager(), vm.getActivityCat()]).then(function() {
                    vm.getActivity()
                }, function() {
                    console.log("error")
                });

            })
        },
        
        data () {
            return {
                class_name: 'org.mobilink.activitymgt.model.Activity',
                // group_id: 20147,
                group_id: themeDisplay.getScopeGroupId(),
                // end_point: 'http://127.0.0.1:8081/api/',
                end_point: '/o/v2/mobilink/',
                mainItems: [],
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
                /*console.log("run get mamager");*/
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
                /*console.log("run get activityCat");*/
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
                /*console.log("run get getActivity");*/
                var vm = this;
                var date = new Date();
                vm.timeStart = new Date(date.getFullYear(), date.getMonth(), 1);
                vm.timeEnd = new Date(date.getFullYear(), date.getMonth() + 1, 0);

                vm.activityListItems=[];
                var paramsGetActivity = {
                    sort:'startDate_Number',
                    type: 'EVENT',
                    fromdate: vm.timeStart?vm.parseDateFormat(vm.timeStart):null,
                    todate: vm.timeEnd?vm.parseDateFormat(vm.timeEnd):null
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
                            vm.activityListItems.push(serializable.data[key])

                        };
                        if(vm.radioGroup=='activityCat'){
                            vm.getListItemGroup(vm.activityCatItems);
                            vm.getListActivityItemsGroup(vm.activityCatItems);
                            vm.getListActivitySource(vm.mainItems[0].activityItems[0].activityId,0,0)
                        } else if(vm.radioGroup=='leader') {
                            vm.getListItemGroup(vm.managerItems);
                            vm.getListActivityItemsGroup(vm.managerItems);
                            vm.getListActivitySource(vm.mainItems[0].activityItems[0].activityId,0,0)
                        };
                        
                    }else {
                        
                    }
                    console.log(vm)
                })
                .catch(function (error) {
                    console.log(error);
                    
                });
            },
            /**Load activity detail */
            activityDetail: function(item, index){
                console.log(item);
                this.$emit('view_detail', item, index);
            },
            callGetActivity: function(){
                var vm = this;
                vm.activityListItems=[];
                vm.mainItems =[];

                var paramsGetActivity = {
                    sort:'startDate',
                    type: 'EVENT',
                    fromdate: vm.timeStart?vm.parseDateFormat(vm.timeStart):null,
                    todate: vm.timeEnd?vm.parseDateFormat(vm.timeEnd):null
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

                        if(vm.radioGroup=='activityCat'){
                            vm.getListItemGroup(vm.activityCatItems);
                            vm.getListActivityItemsGroup(vm.activityCatItems);
                            vm.getListActivitySource(vm.mainItems[0].activityItems[0].activityId,0,0)
                        } else if(vm.radioGroup=='leader') {
                            vm.getListItemGroup(vm.managerItems);
                            vm.getListActivityItemsGroup(vm.managerItems);
                            vm.getListActivitySource(vm.mainItems[0].activityItems[0].activityId,0,0)
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
                vm.getActivity()
            },
            changeDate: function(){
                var vm = this;
                setTimeout(function(){
                    vm.timeEndMin = vm.timeStart?new Date(vm.timeStart):'';
                    vm.timeStartMax = vm.timeEnd?new Date(vm.timeEnd):'';
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
                                vm.mainItems[key].activitySourceItems.push([])
                            }
                        } else if(vm.radioGroup == "leader"&&vm.mainItems.length!=0){
                            if(vm.activityListItems[index].leaderId == vm.mainItems[key].leader.mappingUser.userId){
                                vm.mainItems[key].activityItems.push(vm.activityListItems[index]);
                                vm.mainItems[key].activitySourceItems.push([])
                            }
                        }
                        
                    }
                }
            },
            /** get list source group*/
            getListActivitySource: function(class_pk,indexGroup,index){
                var vm =this;
                var paramsGetSource = {
                    
                };
                const configGetSource = {
                    params: paramsGetSource,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                if(vm.mainItems[indexGroup].activitySourceItems[index].length==0){
                    axios.get( vm.end_point + 'activities/source/'+vm.class_name+'/'+ class_pk, configGetSource)
                    .then(function (response) {
                        var serializable = response.data
                        if (serializable.hasOwnProperty('data')) {
                            for (var key in serializable.data) {
                                vm.mainItems[indexGroup].activitySourceItems[index].push(
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

    #activity_manager .navTable{
        background-color: #fff!important;
    }
    #activity_manager .groupRadido .radio{
        max-width: 150px !important;
    }
    #activity_manager .header-menu{
        height: 40px;
    }
    #activity_manager .listGroup .list__tile:hover{
        cursor: pointer;
        color: blue
    }
    #activity_manager #subTableActivity td a:hover {
        color: blue!important
    }
    #activity_manager .list--group__header--active .list__tile__action > i{
        -webkit-transform: rotate(-180deg);
        -ms-transform: rotate(-180deg);
        transform: rotate(-180deg);
    }
    #activity_manager .list--group__header--active{
        background-color: #cbddf7!important
    }
    #activity_manager .header-menu div{
        text-align: center;
        overflow: hidden;
        text-overflow: ellipsis; 
        white-space: nowrap;
        border: 1px solid #ddd !important;
        padding: 8px 5px!important;
    }
    #activity_manager #list-content .expansion-panel{
        border-bottom: 2px solid #e7e7e7;
    }
    #activity_manager #list-content table tr td{
        overflow: hidden;
        text-overflow: ellipsis; 
        white-space: nowrap;
        border: 1px solid #ddd !important;
        padding: 8px 5px!important;
    }
    #activity_manager .groupHeader p{
        max-width: 100%;
        overflow: hidden;
        text-overflow: ellipsis; 
        white-space: nowrap;
    }
    #activity_manager #list-content table tr td:nth-child(5){
        padding: 0px 5px!important;
    }
    #activity_manager .icon_view:hover{
        color: blue
    }
    #activity_manager .icon_view{
        max-width: 100%;
        overflow: hidden;
        text-overflow: ellipsis; 
        white-space: nowrap;
    }
    #activity_manager .expansion-panel__container{
        width: 100%!important
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
    #activity_manager #subTableActivity table{
        table-layout: fixed
    }
    #activity_manager .mx-datepicker{
        width: 100%!important
    }


</style>

