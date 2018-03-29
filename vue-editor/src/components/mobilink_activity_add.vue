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
                    <v-subheader class="px-0">Thời gian bắt đầu *</v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3"
                    v-model="timeStart" 
                    placeholder="Thời gian bắt đầu"
                    @confirm = "changeDate" 
                    v-bind:not-before="timeStartMin" 
                    :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" 
                    lang="en" type="datetime" format="dd/MM/yyyy HH:mm" 
                    confirm="true"
                    :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                    required
                    ></date-picker>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3 mt-2">
                    <v-subheader class="px-0">Thời gian kết thúc *</v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3" 
                    v-model="timeEnd" 
                    placeholder="Thời gian kết thúc" 
                    v-bind:not-before="timeEndMin" 
                    :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" 
                    lang="en" type="datetime" format="dd/MM/yyyy HH:mm" 
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
                    <v-subheader class="px-0" >Loại sự kiện </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="eventTypeItems"
                        v-model="eventType"
                        placeholder="Chọn loại sự kiện"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-3">
                    <v-subheader class="px-0">Quy trình </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="processItems"
                        v-model="process"
                        placeholder="Chọn quy trình"
                        clearable
                        item-text="subject"
                        item-value="activityId"
                        @change="chooseProcessEvent"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex>

                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Lĩnh vực/ thẻ nhãn </v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-select
                        v-bind:items="labelItems"
                        v-model="label"
                        clearable
                        item-text="name"
                        item-value="labelId"
                        autocomplete
                        return-object
                        hide-selected

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
                    <v-subheader class="px-0">Ngày bắt đầu *</v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-3" 
                    v-model="timeStart" 
                    placeholder="Ngày bắt đầu" 
                    @confirm = "changeDate" 
                    v-bind:not-before="timeStartMin" 
                    :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" 
                    lang="en" type="datetime" format="dd/MM/yyyy HH:mm" 
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
                    <date-picker class="mt-3" v-model="timeEnd" placeholder="Thời hạn hoàn thành" v-bind:not-before="timeEndMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="en" type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
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
                <v-flex xs12 sm4 class="pl-2">
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
                <v-flex xs12 sm2></v-flex>
                <v-flex xs12 sm4>
                    <v-checkbox v-bind:label="`Có ghi lịch`" v-model="noteCalendard"></v-checkbox>
                </v-flex>
                <v-flex xs12 sm6></v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Loại nhiệm vụ </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="taskTypeItems"
                        v-model="taskType"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        placeholder="Chọn loại nhiệm vụ"
                        return-object
                        hide-selected
                        clearable
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Quy trình </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="pl-2">
                    <v-select
                        v-bind:items="processItems"
                        v-model="process"
                        clearable
                        placeholder="Chọn quy trình"
                        @change="chooseProcessTask"
                        item-text="subject"
                        item-value="activityId"
                        autocomplete
                        return-object
                        hide-selected
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

        <!-- Template activity add process-->
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'process'" >
            <v-layout wrap >
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Số hiệu quy trình *</v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-text-field
                        placeholder="Số hiệu quy trình "
                        v-model="processCode"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                </v-flex>
                <v-flex xs12 sm12></v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Tên quy trình *</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Tên quy trình "
                        v-model="processName"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Loại hoạt động </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="processTypeItems"
                        v-model="processType"
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        placeholder="Chọn loại hoạt động"
                        return-object
                        hide-selected
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-select>
                </v-flex>
                <!--  -->
                
                <v-flex xs12 sm2 class="pl-1">
                    <v-subheader class="px-0">Đơn vị chủ trì/ tổ chức </v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="pl-2">
                    <v-select
                        v-bind:items="hostingIdItems"
                        v-model="hostingId"
                        clearable
                        item-text="name"
                        item-value="workingUnitId"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex>
            </v-layout>
        </v-form>
        <!-- end -->

        <!-- Template activity add requests-->
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'requests'" >
            <v-layout wrap >
                
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
                    <date-picker class="mt-2" v-model="timeStart" placeholder="Ngày yêu cầu" @confirm = "changeDate" v-bind:not-before="timeStartMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="en" type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
                </v-flex> -->
                <!--  -->
                <!-- <v-flex xs12 sm2 class="pl-4">
                    <v-subheader class="px-0">Hạn xử lý </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <date-picker class="mt-2" v-model="timeEnd" placeholder="Hạn xử lý" v-bind:not-before="timeEndMin" :time-picker-options ="{start: '00:00',step: '00:10',end: '23:00'}" lang="en" type="datetime" format="dd/MM/yyyy HH:mm" confirm="true"></date-picker>
                </v-flex> -->
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

                        /* Load data quy trình*/
                        axios.get( endPoint + 'activities', configProcess)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.processItems.push({
                                        subject: serializable.data[key].subject,
                                        activityId: serializable.data[key].activityId
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
                        /* Load data thẻ nhãn */
                        var paramsLabels = {
                            scope: "activity"
                        };
                        const configLabels = {
                            params: paramsLabels,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };
                        axios.get( endPoint + 'labels', configLabels)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.labelItems.push({
                                        name: serializable.data[key].name,
                                        labelId: serializable.data[key].labelId
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
                        /* Load data quy trình*/
                        axios.get( endPoint + 'activities', configProcessTask)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.processItems.push({
                                        subject: serializable.data[key].subject,
                                        activityId: serializable.data[key].activityId
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
                        /* Load data quy trình request*/
                        axios.get( endPoint + 'activities', configProcessRequest)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.processItems.push({
                                        subject: serializable.data[key].subject,
                                        activityId: serializable.data[key].activityId
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
                } else if(vm.type_activity == 'tasks' || vm.type_activity == 'requests'){
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
            /**Choose process add event */
            chooseProcessEvent: function(){
                var vm = this;   
                const configChooseProcess = {
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                setTimeout(function(){

                    /* Load data quy trình đã chọn*/
                    if(vm.process){
                        axios.get( vm.end_point + 'activities/'+ vm.process.activityId, configChooseProcess)
                        .then(function (response) {
                            var serializable = response.data;
                            vm.templateNo = serializable.templateNo; 
                            /* console.log('templateNo: '+ vm.templateNo);*/
                            var arrParticipators = [];
                            for (var key in serializable.participators) {
                                arrParticipators.push(
                                    serializable.participators[key].workingUnitId,
                                )
                                
                            };

                            vm.topic = serializable.subject;
                            vm.hostingId = {workingUnitId:serializable.hostingId, name: serializable.hosting };
                            vm.manager = {employeeId:serializable.managerId,fullName: serializable.managerName };
                            
                            vm.location = {locationId:serializable.locationId,location: serializable.location, geolocation:serializable.geolocation };
                            vm.content = serializable.description;
                            /* vm.contact = {itemCode:serializable.contact.contactId,itemName: serializable.contact.fullname};*/
                        })
                        .catch(function (error) {
                            console.log(error)
                        })
                    }
                    
                },1000);
                  
            },
            /**End */

            /**Choose process add task */
            chooseProcessTask: function(){
                var vm = this;   
                const configChooseProcess = {
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                setTimeout(function(){
                    /* Load data quy trình đã chọn*/
                    if(vm.process){
                        axios.get( vm.end_point + 'activities/'+ vm.process.activityId, configChooseProcess)
                        .then(function (response) {
                            var serializable = response.data;
                            vm.templateNo = serializable.templateNo; 

                            vm.taskname = serializable.subject;
                            vm.hostingId = {workingUnitId:serializable.hostingId,name: serializable.hosting };
                            vm.manager = {employeeId:serializable.managerId,fullName: serializable.managerName };
                            vm.noteCalendard = serializable.onCalendar;
                            
                            vm.content = serializable.description;
                            /*vm.contact = {itemCode:serializable.contact.contactId,itemName: serializable.contact.fullname};*/
                        })
                        .catch(function (error) {
                            console.log(error)
                        })
                    }
                    
                },1000);
                  
            },
            /**End */

            /**Choose process add ticket */
            chooseProcessTicket: function(){
                var vm = this;   
                const configChooseTicket = {
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                setTimeout(function(){

                    /* Load data quy trình đã chọn*/
                    if(vm.process){
                        axios.get( vm.end_point + 'activities/'+ vm.process.activityId, configChooseTicket)
                        .then(function (response) {
                            var serializable = response.data;
                            vm.templateNo = serializable.templateNo; 
                            vm.topicRequest = serializable.subject;
                            vm.hostingId = {workingUnitId:serializable.hostingId,name: serializable.hosting };
                            vm.contentRequest = serializable.description;
    
                        })
                        .catch(function (error) {
                            console.log(error)
                        })
                    }   

                },1000);
                  
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
                    paramsAddEvent.append('templateNo', vm.templateNo?vm.templateNo: '')
                    paramsAddEvent.append('onCalendar', true)
                    paramsAddEvent.append('subject', vm.topic?vm.topic:'')
                    paramsAddEvent.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:'')
                    paramsAddEvent.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    paramsAddEvent.append('managerId', vm.manager?vm.manager.employeeId:'')
                    paramsAddEvent.append('labelId', vm.label?vm.label.labelId:'')

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
                        var fixLabel = vm.label?vm.label.labelId:'';
                        var classPK = response.data.activityId;
                        console.log(fixLabel);
                        if(fixLabel){
                            vm.addResourceLabel(vm.className, classPK, fixLabel)
                        }
                        vm.$emit('call-back-add', vm.dataForm);
                    })
                    .catch(function (error) {
                        console.log(error)
                    })
                }
                
            },
            addResourceLabel: function(className,classPK,labelId){
                console.log("run add resourcelabel");
                var vm = this;
                const configPostAddResourceLabel = {
                    headers: {
                        'groupId': vm.group_id
                    }
                };

                var paramsAddResourceLabel = new URLSearchParams();
                paramsAddResourceLabel.append('className', className)
                paramsAddResourceLabel.append('classPK', classPK)
                paramsAddResourceLabel.append('labelId', labelId)
                axios.post(vm.end_point + 'resourcelabels',
                    paramsAddResourceLabel,
                    configPostAddResourceLabel
                )
                .then(function (response) {
                    console.log(response)
                })
                .catch(function (error) {
                    console.log(error)
                })

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
                    paramsAddTask.append('templateNo', vm.templateNo?vm.templateNo:"")
                    paramsAddTask.append('subject', vm.taskname?vm.taskname:"")
                    paramsAddTask.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:"")
                    paramsAddTask.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    paramsAddTask.append('managerId', vm.manager?vm.manager.employeeId:"")
                    
                    paramsAddTask.append('onCalendar', vm.noteCalendard?vm.noteCalendard: false)
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

            submitAddProcess: function () {
                if (this.$refs.form.validate()) {
                    var vm = this;
                
                    const configPostAddProcess = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                    
                    var paramsAddProcess = new URLSearchParams()
                    
                    paramsAddProcess.append('isTemplate', true)
                    paramsAddProcess.append('activityCat', vm.processType?vm.processType.itemCode:"")
                    paramsAddProcess.append('templateNo', vm.processCode?vm.processCode:"")
                    paramsAddProcess.append('subject', vm.processName?vm.processName:"")
                    paramsAddProcess.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:"")
                    paramsAddProcess.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    
                    axios.post(vm.end_point + 'activities',
                        paramsAddProcess,
                        configPostAddProcess
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
                    /*var startDateTicket = vm.parseDateFormat(vm.timeStart);
                    var endDateTicket = vm.parseDateFormat(vm.timeEnd);*/

                    var paramsAddRequest = new URLSearchParams()

                    paramsAddRequest.append('isTemplate', false)
                    paramsAddRequest.append('activityType', "REQUEST")
                    paramsAddRequest.append('activityCat', vm.requestType?vm.requestType.itemCode:"")

                    /*paramsAddRequest.append('templateNo', vm.templateNo?vm.templateNo:"")*/
                    paramsAddRequest.append('subject', vm.topicRequest?vm.topicRequest:"")
                    paramsAddRequest.append('onCalendar', true)
                    paramsAddRequest.append('hostingId', vm.hostingId?vm.hostingId.workingUnitId:"")
                    paramsAddRequest.append('hosting', vm.hostingId?vm.hostingId.name:'')
                    /*paramsAddRequest.append('managerId', vm.manager?vm.manager.employeeId:"")
                    paramsAddRequest.append('startDate', startDateTicket)
                    paramsAddRequest.append('endDate', endDateTicket)*/
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

            submitAdd: function(){
                var vm = this;
                console.log(vm);
                if (vm.type_activity == 'events') {
                    vm.submitAddEvents()
                } else if (vm.type_activity == 'tasks') {
                    vm.submitAddTasks()
                } else if(vm.type_activity == 'process') {
                    vm.submitAddProcess()
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