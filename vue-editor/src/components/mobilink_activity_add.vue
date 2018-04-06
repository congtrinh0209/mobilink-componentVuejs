<template>
    <div :id="'activity_add_'+id" class="activity_add">

        <!-- Template activity add events --> 
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'events'" >
            <v-layout wrap >
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Tên cuộc họp *</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Tên cuộc họp "
                        v-model="topic"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="mt-2">
                    <v-subheader class="px-0">Thời gian bắt đầu </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3"
                    v-model="timeStart" 
                    placeholder="Thời gian bắt đầu"
                    @confirm = "changeDate" 
                    v-bind:not-before="timeStartMin" 
                    :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" 
                    type="datetime" format="dd/MM/yyyy HH:mm" 
                    confirm="true"
                    :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                    required
                    ></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3 mt-2">
                    <v-subheader class="px-0">Thời gian kết thúc </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3" 
                    v-model="timeEnd" 
                    placeholder="Thời gian kết thúc" 
                    v-bind:not-before="timeEndMin" 
                    :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" 
                    lang="vi" type="datetime" format="dd/MM/yyyy HH:mm" 
                    confirm="true"
                    :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                    required
                    ></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Địa điểm </v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-select
                        v-bind:items="locationItems"
                        v-model="location"
                        item-text="location"
                        item-value="locationId"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                    >

                    </v-select>

                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Đơn vị tham mưu </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="hostingIdItems"
                        v-model="hostingId"
                        item-text="name"
                        item-value="workingUnitId"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3">
                    <v-subheader class="px-0">Lãnh đạo chủ trì </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="managerItems"
                        v-model="manager"
                        clearable
                        item-text="fullName"
                        item-value="employeeId"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex>
                
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0" >Lĩnh vực </v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-select
                        v-bind:items="eventTypeItems"
                        v-model="eventType"
                        placeholder="Chọn lĩnh vực"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>

                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Nội dung</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Nội dung "
                        v-model="content"
                        multi-line
                    ></v-text-field>
                </v-flex>
                
            </v-layout>
        </v-form>
        <!-- end -->
        
        <!-- Template activity add tasks-->
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'tasks'" >
            <v-layout wrap >
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Tên nhiệm vụ *</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Tên nhiệm vụ "
                        v-model="taskname"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="mt-2">
                    <v-subheader class="px-0">Ngày bắt đầu </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3" 
                    v-model="timeStart" 
                    placeholder="Ngày bắt đầu" 
                    @confirm = "changeDate" 
                    v-bind:not-before="timeStartMin" 
                    :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" 
                    lang="vi" type="datetime" format="dd/MM/yyyy HH:mm" 
                    confirm="true"
                    :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                    required
                    ></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2 mt-2">
                    <v-subheader class="px-0">Thời hạn hoàn thành </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3" v-model="timeEnd" placeholder="Thời hạn hoàn thành" 
                    v-bind:not-before="timeEndMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="vi" 
                    type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Đơn vị chủ trì *</v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="hostingIdItems"
                        v-model="hostingId"
                        item-text="name"
                        item-value="workingUnitId"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Người phụ trách </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="">
                    <v-select
                        v-bind:items="managerItems"
                        v-model="manager"
                        clearable
                        item-text="fullName"
                        item-value="employeeId"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Lĩnh vực </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="taskTypeItems"
                        v-model="taskType"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        placeholder="Chọn lĩnh vực"
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Độ ưu tiên </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="priorityItems"
                        v-model="priority"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        placeholder="Chọn mức độ ưu tiên"
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!-- <v-flex xs12 sm6> 
                    <v-checkbox v-bind:label="`Có ghi lịch`" v-model="noteCalendard"></v-checkbox>
                </v-flex> -->
                
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Nội dung</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Nội dung "
                        v-model="content"
                        multi-line
                    ></v-text-field>
                </v-flex>
            </v-layout>
            
        </v-form>
        <!-- end -->

        <!-- Template activity add plan-->
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'plans'" >
            <v-layout wrap >
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Tên kế hoạch *</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Tên kế hoạch "
                        v-model="planName"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="mt-2">
                    <v-subheader class="px-0">Ngày bắt đầu </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3" 
                    v-model="timeStart" 
                    placeholder="Ngày bắt đầu" 
                    @confirm = "changeDate" 
                    v-bind:not-before="timeStartMin" 
                    :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" 
                    lang="vi" type="datetime" format="dd/MM/yyyy HH:mm" 
                    confirm="true"
                    :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                    required
                    ></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2 mt-2">
                    <v-subheader class="px-0">Ngày kết thúc </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3" v-model="timeEnd" placeholder="Ngày kết thúc" 
                    v-bind:not-before="timeEndMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="vi" 
                    type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Đơn vị quản lý *</v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="hostingIdItems"
                        v-model="hostingId"
                        item-text="name"
                        item-value="workingUnitId"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Người phụ trách </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="">
                    <v-select
                        v-bind:items="managerItems"
                        v-model="manager"
                        clearable
                        item-text="fullName"
                        item-value="employeeId"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Lĩnh vực </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="planTypeItems"
                        v-model="planType"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        placeholder="Chọn lĩnh vực"
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Độ ưu tiên </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="priorityItems"
                        v-model="priority"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        placeholder="Chọn mức độ ưu tiên"
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>

                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Nội dung</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Nội dung "
                        v-model="content"
                        multi-line
                    ></v-text-field>
                </v-flex>
            </v-layout>
            
        </v-form>
        <!-- end -->

        <!-- Template activity add requests-->
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'requests'" >
            <v-layout wrap >
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Loại yêu cầu </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="requestTypeItems"
                        v-model="requestType"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Đơn vị xử lý </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="hostingIdItems"
                        v-model="hostingId"
                        item-text="name"
                        item-value="workingUnitId"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Chủ đề *</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Chủ đề "
                        v-model="topicRequest"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Mô tả</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Mô tả "
                        v-model="contentRequest"
                        multi-line
                    ></v-text-field>
                </v-flex>
                <!--  -->
                <!-- <v-flex xs12 sm2>
                    <v-subheader class="px-0">Ngày yêu cầu </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-2" v-model="timeStart" placeholder="Ngày yêu cầu" @confirm = "changeDate" v-bind:not-before="timeStartMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="vi" type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
                </v-flex> -->
                <!--  -->
                <!-- <v-flex xs12 sm2 class="pl-4">
                    <v-subheader class="px-0">Hạn xử lý </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-2" v-model="timeEnd" placeholder="Hạn xử lý" v-bind:not-before="timeEndMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="vi" type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
                </v-flex> -->
                
                <!-- <v-flex xs12 sm2 class="pl-4">
                    <v-subheader class="px-0">Quy trình </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="processItems"
                        v-model="process"
                        clearable
                        @change="chooseProcessTicket"
                        item-text="subject"
                        item-value="activityId"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex> -->
                
                <!--  -->
                
                <!--  -->
                <!-- <v-flex xs12 sm2 class="pl-4">
                    <v-subheader class="px-0">Người phụ trách </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="managerItems"
                        v-model="manager"
                        clearable
                        item-text="fullName"
                        item-value="employeeId"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex> -->

            </v-layout>
        </v-form>
        <!-- end -->

        <!-- Template activity add tickets-->
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'tickets'" >
            <v-layout wrap >

                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Tên đề xuất *</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder=""
                        v-model="ticketName"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Ngày đề xuất</v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-2" v-model="timeStart" placeholder="Ngày yêu cầu" @confirm = "changeDate" v-bind:not-before="timeStartMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="vi" type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
                </v-flex> 
                <!--  -->
                <v-flex xs12 sm2 class="pl-4">
                    <v-subheader class="px-0">Hạn xử lý </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-2" v-model="timeEnd" placeholder="Hạn xử lý" v-bind:not-before="timeEndMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="vi" type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
                </v-flex>
                
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Đơn vị xử lý * </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="hostingIdItems"
                        v-model="hostingId"
                        item-text="name"
                        item-value="workingUnitId"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Loại đề xuất </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="ticketTypeItems"
                        v-model="ticketType"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Mô tả</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Mô tả "
                        v-model="contentTicket"
                        multi-line
                    ></v-text-field>
                </v-flex>

            </v-layout>
        </v-form>
        <!-- end -->

    </div>
</template>

<script>
    const COMPONENT_NAME = 'jx-mobilink-activity-add'
    export default {
        name: COMPONENT_NAME,
        props: {
            id: null,
            class_pk: null,
            class_name: null,
            group_id: null,
            type_activity: null,
            end_point: null,
            dataForm: null
        },
        created () {
            
        },

        data () {
            return {
                eventTypeItems:[],
                eventType:'',
                topic:'',
                hostingIdItems:[],
                hostingId:'',
                participatorsItems: [],
                participators:'',
                address:'',
                projectItems:[],
                project:'',
                content:'',
                locationItems:[],
                location:'',
                geolocation:'',
                contactItems:[],
                contact:'',
                taskTypeItems:[],
                taskType:'',
                processItems:[],
                process:'',
                taskname:'',
                taskParentItems:[],
                taskParent:'',
                managerItems:[],
                planName: '',
                planTypeItems: [],
                planType:'',
                ticketName:'',
                ticketTypeItems: [],
                ticketType: '',
                contentTicket: '',
                manager:'',
                processCode:'',
                processName:'',
                processTypeItems:[],
                processType:'',
                requestTypeItems: [],
                requestEmpItems:[],
                requestEmp:'',
                requestType:'',
                topicRequest:'',
                contentRequest:'',
                templateNo:'',
                labelItems:[],
                label:'',
                priorityItems:[
                    {'itemCode': 0,'itemName': 'Thường'},
                    {'itemCode': 1,'itemName': 'Cao'},
                    {'itemCode': 2,'itemName': 'Khẩn'}
                ],
                priority:'',
                className:'org.mobilink.activitymgt.model.Activity',

                valid: false,
                noteCalendard: false,
                timeStart: '',
                timeStartMin: '',
                timeEnd: '',
                timeEndMin:'',
                timeEndEvent: '',
                timeEvent: null,
                timeTask:null,
                timeStartTicket: '',
                timeTicket: null,
                timeEndEvent2: null,
                timeEndTask:'',
                timeEndTask2:null,
                timeEndTicket: '',
                timeEndTicket2: null,
                dueDate: '',
                dueDateMd: null,
                dueDateMenu: false,
                promulgationDate: '',
                promulgationDateMd:'',
                promulgationDateMenu: false,
                startDateMax: null,
                endDateMin:null,
                
                /** */
                
            }
        },
        methods: {
            initGetData() {
                var vm = this;
                var endPoint = vm.end_point
                /** */
                var paramsBuilder = {
                    
                };
                const config = {
                    params: paramsBuilder,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                /** */
                var paramsTypeEvent = {
                    parent: 'EVENT'
                };
                const configTypeEvent = {
                    params: paramsTypeEvent,
                    headers: {
                        'groupId': vm.group_id
                    }
                };         
                /** */
                var paramsContact = {
                    
                };
                const configContact = {
                    params: paramsContact,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                
                /** */
                var paramsProcess = {
                    type: "EVENT",
                    template: true
                };
                const configProcess = {
                    params: paramsProcess,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                
                /** */
                vm.$nextTick(function () {
                    console.log('component add activity type:' +  vm.type_activity);
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
                    
                /* Get API for EVENTS */
                    if (vm.type_activity == 'events') {
                        
                        /* LOAD data loại sự kiện*/
                        axios.get( endPoint + 'dictcollections/ACTIVITY_TYPE/dictitems', configTypeEvent)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.eventTypeItems.push({
                                        itemName: serializable.data[key].itemName,
                                        itemCode: serializable.data[key].itemCode
                                    })
                                    
                                }
                            }
                        })
                        .catch(function (error) {
                            console.log(error)
                        });

                        /* Load data địa điểm*/
                        axios.get( endPoint + 'locations', config)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.locationItems.push({
                                        location: serializable.data[key].location,
                                        locationId: serializable.data[key].locationId,
                                        geolocation: serializable.data[key].geolocation
                                    })
                                    
                                }
                            }
                        })
                        .catch(function (error) {
                            console.log(error)
                        })

                        /* Load data contact */
                        axios.get( endPoint + 'contacts', configContact)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    if(serializable.data[key].contactType == 0||serializable.data[key].contactType==1){
                                        vm.contactItems.push({
                                            itemName: serializable.data[key].fullName,
                                            itemCode: serializable.data[key].contactId
                                        })
                                    }
                                }
                            }
                        })
                        .catch(function (error) {
                            console.log(error)
                        });

                        vm.getCurrentDate();
  
                    }
                /* Get API for TASKS */
                    else if (vm.type_activity == 'tasks') {
                        var paramsTypeTask = {
                            parent: 'TASK'
                        };
                        const configTypeTask = {
                            params: paramsTypeTask,
                            headers: {
                                'groupId': vm.group_id
                            }

                        };
                        var paramsProcessTask = {
                            type: "TASK",
                            template: true
                        };
                        const configProcessTask = {
                            params: paramsProcessTask,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };

                        /* */
                        var paramsProject = {
                            
                        };
                        const configProject = {
                            params: paramsProject,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };
                        /* LOAD data loại nhiệm vụ*/
                        axios.get( endPoint + 'dictcollections/ACTIVITY_TYPE/dictitems', configTypeTask)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.taskTypeItems.push({
                                        itemName: serializable.data[key].itemName,
                                        itemCode: serializable.data[key].itemCode
                                    })
                                    
                                }
                            }
                        })
                        .catch(function (error) {
                            console.log(error)
                        });

                        vm.getCurrentDate();
                    }
                /* Get API for PROCESS */
                    else if (vm.type_activity == 'process') {
                        
                        var paramsProcess = {
                            
                        };
                        const configProcess = {
                            params: paramsProcess,
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
                        /* Load data loại hoạt động*/
                        axios.get( endPoint + 'dictcollections/ACTIVITY_TYPE/dictitems', configTypeProcess)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    if (serializable.data[key].level === 0) {
                                        vm.processTypeItems.push({
                                            header: serializable.data[key].itemName
                                        })
                                    } else {
                                        vm.processTypeItems.push({
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
                    }
                /* Get API for REQUESTS */
                    else if (vm.type_activity == 'requests') {
                        var paramsTypeRequest = {
                            parent: 'REQUEST'
                        };
                        const configTypeRequest = {
                            params: paramsTypeRequest,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };
                        /*  */
                        var paramsProcessRequest = {
                            type: "REQUEST",
                            template: true
                        };
                        const configProcessRequest = {
                            params: paramsProcessRequest,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };
                        /* LOAD data loại yêu cầu */
                        axios.get( endPoint + 'dictcollections/ACTIVITY_TYPE/dictitems', configTypeRequest)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.requestTypeItems.push({
                                        itemName: serializable.data[key].itemName,
                                        itemCode: serializable.data[key].itemCode
                                    })
                                    
                                }
                            }
                        })
                        .catch(function (error) {
                            console.log(error)
                        });
                        
                        vm.getCurrentDate();
                    }
                /* Get API for PLANS */
                    else if (vm.type_activity == 'plans') {
                        var paramsTypePlan = {
                            parent: 'PLAN'
                        };
                        const configTypePlan = {
                            params: paramsTypePlan,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };
                        
                        /* LOAD data loại yêu cầu */
                        axios.get( endPoint + 'dictcollections/ACTIVITY_TYPE/dictitems', configTypePlan)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.planTypeItems.push({
                                        itemName: serializable.data[key].itemName,
                                        itemCode: serializable.data[key].itemCode
                                    })
                                    
                                }
                            }
                        })
                        .catch(function (error) {
                            console.log(error)
                        });

                        vm.getCurrentDate();
                    }
                /* Get API for TICKETS */
                    else if (vm.type_activity == 'tickets') {
                        var paramsTypeTicket = {
                            parent: 'TICKET'
                        };
                        const configTypeTicket = {
                            params: paramsTypeTicket,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };
                        
                        /* LOAD data loại yêu cầu */
                        axios.get( endPoint + 'dictcollections/ACTIVITY_TYPE/dictitems', configTypeTicket)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.ticketTypeItems.push({
                                        itemName: serializable.data[key].itemName,
                                        itemCode: serializable.data[key].itemCode
                                    })
                                    
                                }
                            }
                        })
                        .catch(function (error) {
                            console.log(error)
                        });

                        vm.getCurrentDate();
                    }    
                })
            },
            formatDate (date) {
                if (!date) {
                    return null
                }
                const [year, month, day] = date.split('-')
                return `${day}/${month}/${year}`
            },
            getCurrentDate: function(){
                var vm = this;
                vm.timeStart = vm.roundDate(30,new Date());
                vm.timeStartMin = new Date();
                vm.timeEndMin = new Date();
                var timeEnd = new Date();
                if(vm.type_activity == 'events'){
                    timeEnd.setHours(timeEnd.getHours() + 2);
                } else if(vm.type_activity == 'tasks' || vm.type_activity == 'tickets'|| vm.type_activity == 'plans'){
                    timeEnd.setHours(timeEnd.getHours() + 24);
                };
                vm.timeEnd = vm.roundDate(30,timeEnd);
                
                /* */
            },
            
            roundDate(minutes, d){
                var milisecond = 1000 * 60 * minutes; // đổi ra milisecond
                var newdate = new Date(Math.ceil(d.getTime() / milisecond) * milisecond);
                return newdate
            },
                

            parseDate (date) {
                if (!date) {
                    return null
                }
                const [day, month, year] = date.split('/')
                return `${year}-${month.padStart(2, '0')}-${day.padStart(2, '0')}`
            },
            parseCurrentDate (date) {
                if (!date) {
                    return null
                }
                const [day, month, year] = date.split('/')
                return `${day.padStart(2, '0')}/${month.padStart(2, '0')}/${year}`
            },
            parseCurrentTime (time) {
                if (!time) {
                    return null
                }
                const [hh, mm] = time.split(':')
                return `${hh.padStart(2, '0')}:${mm.padStart(2, '0')}`
            },
            /** */
            changeDate: function(){
                var vm = this;
                setTimeout(function(){
                    var timeEnd = new Date(vm.timeStart);
                    if(vm.type_activity == 'events'){
                        timeEnd.setHours(timeEnd.getHours() + 2);
                    } else if(vm.type_activity == 'tasks' || vm.type_activity == 'requests'){
                        timeEnd.setHours(timeEnd.getHours() + 24);
                    };
                    vm.timeEnd = timeEnd;
                    vm.timeEndMin = new Date(vm.timeStart)
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

            /**End */
            submitAddEvents: function () {
                if (this.$refs.form.validate()) {
                    var vm = this;    
                    const configPostAddEvent = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                    var startDateEvent = vm.parseDateFormat(vm.timeStart);
                    var endDateEvent = vm.parseDateFormat(vm.timeEnd);

                    var paramsAddEvent = new URLSearchParams()

                    paramsAddEvent.append('isTemplate', false)
                    paramsAddEvent.append('activityType', 'EVENT')
                    paramsAddEvent.append('activityCat', vm.eventType?vm.eventType.itemCode: '')
                    paramsAddEvent.append('subject', vm.topic?vm.topic:'')
                    paramsAddEvent.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:'')
                    paramsAddEvent.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    paramsAddEvent.append('leaderId', vm.manager?vm.manager.employeeId:'')
                    /* paramsAddEvent.append('labelId', vm.label?vm.label.labelId:'')*/

                    paramsAddEvent.append('startDate', startDateEvent)
                    paramsAddEvent.append('endDate', endDateEvent)
                    paramsAddEvent.append('locationId', vm.location?vm.location.locationId:'')
                    paramsAddEvent.append('location', vm.location?vm.location.location:'')
                    paramsAddEvent.append('geolocation', vm.location?vm.location.geolocation:'')
                    paramsAddEvent.append('description', vm.content?vm.content:'')
                    /*paramsAddEvent.append('contactId', vm.contact?vm.contact.itemCode:'')*/
                    
                    axios.post(vm.end_point + 'activities',
                        paramsAddEvent,
                        configPostAddEvent
                    )
                    .then(function (response) {
                        vm.dataForm = response.data;
                        vm.$emit('call-back-add', vm.dataForm);
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
                }
                
            },
            submitAddTasks: function () {
                if (this.$refs.form.validate()) {
                    var vm = this;
                
                    const configPostAddTask = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                    /** */
                    var startDateTask = vm.parseDateFormat(vm.timeStart);
                    var endDateTask = vm.parseDateFormat(vm.timeEnd);

                    var paramsAddTask = new URLSearchParams()

                    paramsAddTask.append('isTemplate', false)
                    paramsAddTask.append('activityType', "TASK")
                    paramsAddTask.append('activityCat', vm.taskType?vm.taskType.itemCode:"")
                    paramsAddTask.append('priority', vm.priority?vm.priority.itemCode:"")
                    paramsAddTask.append('subject', vm.taskname?vm.taskname:"")
                    paramsAddTask.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:"")
                    paramsAddTask.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    paramsAddTask.append('leaderId', vm.manager?vm.manager.employeeId:"")

                    paramsAddTask.append('startDate', startDateTask)
                    paramsAddTask.append('endDate', endDateTask)
                    paramsAddTask.append('description', vm.content?vm.content:"")
                
                    axios.post(vm.end_point + 'activities',
                        paramsAddTask,
                        configPostAddTask
                    )
                    .then(function (response) {
                        vm.dataForm = response.data;
                        vm.$emit('call-back-add', vm.dataForm);
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
                }
                
            },
            submitAddPlans: function () {
                if (this.$refs.form.validate()) {
                    var vm = this;
                
                    const configPostAddPlan = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                    /** */
                    var startDatePlan = vm.parseDateFormat(vm.timeStart);
                    var endDatePlan = vm.parseDateFormat(vm.timeEnd);

                    var paramsAddPlan = new URLSearchParams()

                    paramsAddPlan.append('isTemplate', false)
                    paramsAddPlan.append('activityType', "PLAN")
                    paramsAddPlan.append('activityCat', vm.planType?vm.planType.itemCode:"")
                    paramsAddPlan.append('priority', vm.priority?vm.priority.itemCode:"")
                    paramsAddPlan.append('subject', vm.planName?vm.planName:"")
                    paramsAddPlan.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:"")
                    paramsAddPlan.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    paramsAddPlan.append('leaderId', vm.manager?vm.manager.employeeId:"")

                    paramsAddPlan.append('startDate', startDatePlan)
                    paramsAddPlan.append('endDate', endDatePlan)
                    paramsAddPlan.append('description', vm.content?vm.content:"")
                
                    axios.post(vm.end_point + 'activities',
                        paramsAddPlan,
                        configPostAddPlan
                    )
                    .then(function (response) {
                        vm.dataForm = response.data;
                        vm.$emit('call-back-add', vm.dataForm);
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
                }
                
            },
            submitAddRequests: function () {
                if (this.$refs.form.validate()) {
                    var vm = this;
                
                    const configPostAddRequest = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                    /** */
                    var paramsAddRequest = new URLSearchParams()

                    paramsAddRequest.append('isTemplate', false)
                    paramsAddRequest.append('activityType', "REQUEST")
                    paramsAddRequest.append('activityCat', vm.requestType?vm.requestType.itemCode:"")
                    paramsAddRequest.append('subject', vm.topicRequest?vm.topicRequest:"")
                    paramsAddRequest.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:"")
                    paramsAddRequest.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    paramsAddRequest.append('description', vm.contentRequest?vm.contentRequest:"")
                
                    axios.post(vm.end_point + 'activities',
                        paramsAddRequest,
                        configPostAddRequest
                    )
                    .then(function (response) {
                        vm.dataForm = response.data;
                        vm.$emit('call-back-add', vm.dataForm);
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
                }
                
            },
            submitAddTickets: function () {
                if (this.$refs.form.validate()) {
                    var vm = this;
                
                    const configPostAddTicket = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                    /** */
                    var startDateTicket = vm.parseDateFormat(vm.timeStart);
                    var endDateTicket = vm.parseDateFormat(vm.timeEnd);

                    var paramsAddTicket = new URLSearchParams()

                    paramsAddTicket.append('isTemplate', false)
                    paramsAddTicket.append('activityType', "TICKET")
                    paramsAddTicket.append('activityCat', vm.ticketType?vm.ticketType.itemCode:"")
                    paramsAddTicket.append('subject', vm.ticketName?vm.ticketName:"")
                    paramsAddTicket.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:"")
                    paramsAddTicket.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    paramsAddTicket.append('startDate', startDateTicket)
                    paramsAddTicket.append('endDate', endDateTicket)
                    paramsAddTicket.append('description', vm.contentTicket?vm.contentTicket:"")
                
                    axios.post(vm.end_point + 'activities',
                        paramsAddTicket,
                        configPostAddTicket
                    )
                    .then(function (response) {
                        vm.dataForm = response.data;
                        vm.$emit('call-back-add', vm.dataForm);
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
                }
                
            },

            submitAdd: function(){
                var vm = this;
                console.log(vm);
                if (vm.type_activity == 'events') {
                    vm.submitAddEvents()
                } else if (vm.type_activity == 'tasks') {
                    vm.submitAddTasks()
                } else if (vm.type_activity == 'plans') {
                    vm.submitAddPlans()
                } else if(vm.type_activity == 'tickets') {
                    vm.submitAddTickets()
                } else if (vm.type_activity == 'requests') {
                    vm.submitAddRequests()
                }

            },
            
            clearDataForm: function() {
                var vm =this;
                vm.$refs.form.reset();
                vm.valid = false;
                vm.endDateMin= null;
                vm.startDateMax= null;
                vm.processTypeItems = []
            }
        }
    }
</script>

<style scoped>
    .activity_add {
        margin-top: 35px;
    }
    .activity_add .input-group {
        padding-top: 9px;
    }
    .mx-datepicker{
        width: 100%!important
    }
</style>