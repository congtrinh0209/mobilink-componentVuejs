<template>

    <div id="activity_manager">
        <v-layout wrap class="navTable px-3 py-3">
            <v-flex xs2 sm2>
                <v-subheader class="px-0">Nhóm theo: </v-subheader>
            </v-flex>
            <v-flex xs10 sm10 class="pt-2">
                <v-radio-group class="py-0" v-model="radioGroup" row>
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
            item-key="hosting"
            hide-actions
            expand
            >
                <template slot="items" scope="props">
                    <tr @click="props.expanded = !props.expanded" v-bind:class="{'active': props.index%2==1}">
                        <td colspan="100%" class="px-0">
                            <v-card class="pl-3">
                                <v-card-text>
                                    {{ props.item.hosting }}
                                </v-card-text>
                            </v-card>
                        </td>
                        
                    </tr>
                  
                </template>

                <template slot="expand" scope="props">
                        <v-data-table id="subTableActivity"
                        hide-headers
                        :items="subItems"
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
            })
        },
        
        data () {
            return {
                userId: '',
                radioGroup:'',
                managerItems: [],
                manager:'',
                hostingIdItems:[],
                hostingId:'',
                timeStart:'',
                timeEnd:'',

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
                ],

                mainItems: [
                   {hosting: 'Phòng Dự án1', hostingId: 1},
                   {hosting: 'Phòng Dự án2', hostingId: 2},
                   {hosting: 'Phòng Dự án3', hostingId: 3},
                   {hosting: 'Phòng Dự án4', hostingId: 4},
                   {hosting: 'Phòng Dự án5', hostingId: 5},
                ],
                subItems: [
                    { activityId: 1, subject: 'Hoạt động triển khai khoa học kỹ thuật trong XD 1',hosting: 'FDS CTCP',
                    endDate: '20/08/2018', stateName: 'Đang diễn ra', resultNote: 'Triển khai đúng tiến độ' },
                    { activityId: 2, subject: 'Hoạt động triển khai khoa học kỹ thuật trong XD 2',hosting: 'FDS CTCP',
                    endDate: '20/08/2018', stateName: 'Đang diễn ra', resultNote: 'Triển khai đúng tiến độ' },
                    { activityId: 3, subject: 'Hoạt động triển khai khoa học kỹ thuật trong XD 3',hosting: 'FDS CTCP',
                    endDate: '20/08/2018', stateName: 'Đang diễn ra', resultNote: 'Triển khai đúng tiến độ' },
                    { activityId: 4, subject: 'Hoạt động triển khai khoa học kỹ thuật trong XD 4',hosting: 'FDS CTCP',
                    endDate: '20/08/2018', stateName: 'Đang diễn ra', resultNote: 'Triển khai đúng tiến độ' },
                    { activityId: 5, subject: 'Hoạt động triển khai khoa học kỹ thuật trong XD',hosting: 'FDS CTCP',
                    endDate: '20/08/2018', stateName: 'Đang diễn ra', resultNote: 'Triển khai đúng tiến độ' },
                    { activityId: 6, subject: 'Hoạt động triển khai khoa học kỹ thuật trong XD',hosting: 'FDS CTCP',
                    endDate: '20/08/2018', stateName: 'Đang diễn ra', resultNote: 'Triển khai đúng tiến độ' },
                    { activityId: 7, subject: 'Hoạt động triển khai khoa học kỹ thuật trong XD',hosting: 'FDS CTCP',
                    endDate: '20/08/2018', stateName: 'Đang diễn ra', resultNote: 'Triển khai đúng tiến độ' },
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
            },
            /* Load data activity */
            getActivity: function(){
                var vm = this;
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
                        vm.activityListItems = serializable.data;
                        
                    }  else {
                        vm.activityListItems = [];

                    }
                })
                .catch(function (error) {
                    console.log(error);
                    vm.activityListItems = [];
                });
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
</style>

