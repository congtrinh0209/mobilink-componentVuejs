<template>
    <div :id="'activity_add_'+id" class="activity_add">

        <!-- Template activity add events --> 
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'events'" >
            <v-layout wrap >
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Chủ đề </v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-text-field
                        placeholder="Chủ đề "
                        v-model="topic"
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                        required
                    ></v-text-field>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Đơn vị tổ chức </v-subheader>
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
                        
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Người chủ trì </v-subheader>
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
                    <v-subheader class="px-0">Thời gian bắt đầu </v-subheader>
                </v-flex>
                    <!-- picker time -->
                <v-flex xs11 sm1>
                    <v-menu
                    ref="menuEvent1"
                    lazy
                    :close-on-content-click="false"
                    v-model="timeStartEvent"
                    
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-right="40"
                    max-width="290px"
                    min-width="290px"
                    :return-value.sync="timeEvent"
                    >
                    <v-text-field
                        slot="activator"
                        v-model="timeEvent"

                        placeholder="hh:mm"
                        readonly
                    ></v-text-field>
                    <v-time-picker v-model="timeEvent" format="24hr" @change="$refs.menuEvent1.save(timeEvent)"></v-time-picker>
                    </v-menu>
                </v-flex>
                    <!-- picker date -->
                <v-flex xs12 sm3 class="pl-0">
                    <v-menu
                    lazy
                    :close-on-content-click = "true"
                    v-model = "dueDateMenu"
                    transition = "scale-transition"
                    offset-y
                    full-width
                    :nudge-top = "40"
                    max-width = "290px"
                    min-width = "290px"
                    >
                        <v-text-field
                            slot="activator"
                            placeholder="dd/mm/yyyy"
                            v-model="dueDate"
                            
                            @blur="dueDateMd = parseDate(dueDate)"
                            
                        ></v-text-field>
                        <v-date-picker v-model="dueDateMd" :max="startDateMax" @change="changeDate" @input="dueDate = formatDate($event)" autosave locale="vi">
                        </v-date-picker>
                    </v-menu>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Thời gian kết thúc </v-subheader>
                </v-flex>
                    <!-- picker time -->
                <v-flex xs11 sm1>
                    <v-menu
                    ref="menuEvent2"
                    lazy
                    :close-on-content-click="false"
                    v-model="timeEndEvent"
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-right="40"
                    max-width="290px"
                    min-width="290px"
                    :return-value.sync="timeEndEvent2"
                    >
                    <v-text-field
                        slot="activator"
                        v-model="timeEndEvent2"
                        
                        placeholder="hh:mm"
                        readonly
                    ></v-text-field>
                    <v-time-picker v-model="timeEndEvent2" format="24hr" @change="$refs.menuEvent2.save(timeEndEvent2)"></v-time-picker>
                    </v-menu>
                </v-flex>
                    <!-- picker date -->
                <v-flex xs12 sm3 class="pl-0">
                    <v-menu
                    lazy
                    :close-on-content-click="true"
                    v-model="promulgationDateMenu"
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-top="40"
                    max-width="290px"
                    min-width="290px"
                    >
                        <v-text-field
                            slot="activator"
                            placeholder="dd/mm/yyyy"
                            v-model="promulgationDate"
                            
                            @blur="promulgationDateMd = parseDate(promulgationDate)"
                            
                        ></v-text-field>
                        <v-date-picker v-model="promulgationDateMd" :min="endDateMin" @change="changeDate" @input="promulgationDate = formatDate($event)" autosave locale="vi">
                        </v-date-picker>
                    </v-menu>
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
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        return-object
                        hide-selected
                        
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Quy trình </v-subheader>
                </v-flex>
                <v-flex xs12 sm4>
                    <v-select
                        v-bind:items="processItems"
                        v-model="process"
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

                <!-- <v-flex xs12 sm2>
                    <v-subheader class="px-0">Đơn vị phối hợp </v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-select
                    v-bind:items="participatorsItems"
                    v-model="participators"
                    item-text="name"
                    item-value="workingUnitId"
                    multiple
                    chips
                    max-height="auto"
                    autocomplete
                    >
                        <template slot="selection" slot-scope="data">
                        <v-chip
                            close
                            @input="data.parent.selectItem(data.item)"
                        >
                            {{ data.item.name }}
                        </v-chip>
                        </template>
                    </v-select>
                </v-flex> -->
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Người liên hệ </v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-select
                        v-bind:items="contactItems"
                        v-model="contact"
                        clearable
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        return-object
                        hide-selected

                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Nội dung:</v-subheader>
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
                    <v-subheader class="px-0">Tên nhiệm vụ </v-subheader>
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
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Đơn vị chủ trì </v-subheader>
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
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Ngày bắt đầu </v-subheader>
                </v-flex>
                    <!-- picker time -->
                <v-flex xs11 sm1>
                    <v-menu
                    ref="menuTask1"
                    lazy
                    :close-on-content-click="false"
                    v-model="timeStartTask"
                    
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-right="40"
                    max-width="290px"
                    min-width="290px"
                    :return-value.sync="timeTask"
                    >
                    <v-text-field
                        slot="activator"
                        v-model="timeTask"

                        placeholder="hh:mm"
                        readonly
                    ></v-text-field>
                    <v-time-picker v-model="timeTask" format="24hr" @change="$refs.menuTask1.save(timeTask)"></v-time-picker>
                    </v-menu>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm3 class="pl-0">
                    <v-menu
                    lazy
                    :close-on-content-click = "true"
                    v-model = "dueDateMenu"
                    transition = "scale-transition"
                    offset-y
                    full-width
                    :nudge-top = "40"
                    max-width = "290px"
                    min-width = "290px"
                    >
                        <v-text-field
                            slot="activator"
                            
                            placeholder="dd/mm/yyyy"
                            v-model="dueDate"
                            @blur="dueDateMd = parseDate(dueDate)"
                            
                        ></v-text-field>
                        <v-date-picker v-model="dueDateMd" :max="startDateMax" @change="changeDate" @input="dueDate = formatDate($event)" autosave locale="vi">
                        </v-date-picker>
                    </v-menu>
                </v-flex>

                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Thời hạn hoàn thành </v-subheader>
                </v-flex>
                    <!-- picker time -->
                <v-flex xs11 sm1 class="pl-2">
                    <v-menu
                    ref="menuTask2"
                    lazy
                    :close-on-content-click="false"
                    v-model="timeEndTask"
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-right="40"
                    max-width="290px"
                    min-width="290px"
                    :return-value.sync="timeEndTask2"
                    >
                    <v-text-field
                        slot="activator"
                        v-model="timeEndTask2"
                        
                        placeholder="hh:mm"
                        readonly
                    ></v-text-field>
                    <v-time-picker v-model="timeEndTask2" format="24hr" @change="$refs.menuTask2.save(timeEndTask2)"></v-time-picker>
                    </v-menu>
                </v-flex>
                <v-flex xs12 sm3>
                    <v-menu
                    lazy
                    :close-on-content-click="true"
                    v-model="promulgationDateMenu"
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-top="40"
                    max-width="290px"
                    min-width="290px"
                    >
                        <v-text-field
                            slot="activator"
                            placeholder="dd/mm/yyyy"
                            v-model="promulgationDate"
                            @blur="promulgationDateMd = parseDate(promulgationDate)"
                            clearable = 'true'
                        ></v-text-field>
                        <v-date-picker v-model="promulgationDateMd" :min="endDateMin" @change="changeDate" @input="promulgationDate = formatDate($event)" autosave locale="vi">
                        </v-date-picker>
                    </v-menu>
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
                        return-object
                        hide-selected
                        
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
                        @change="chooseProcessTask"
                        item-text="subject"
                        item-value="activityId"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex>

                <!--  -->
                <!-- <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Dự án / chương trình</v-subheader>
                </v-flex>
                <v-flex xs12 sm4 class="pl-2">
                    <v-select
                        v-bind:items="projectItems"
                        v-model="project"
                        clearable
                        item-text="projectName"
                        item-value="projectId"
                        autocomplete
                        return-object
                        hide-selected
                    ></v-select>
                </v-flex> -->
                <!--  -->
                <!-- <v-flex xs12 sm2>
                    <v-subheader class="px-0">Liên hệ</v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-select
                        v-bind:items="contactItems"
                        v-model="contact"
                        clearable
                        item-text="itemName"
                        item-value="itemCode"
                        autocomplete
                        return-object
                        hide-selected
                        required
                    ></v-select>
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

        <!-- Template activity add process-->
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'process'" >
            <v-layout wrap >
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Số hiệu quy trình </v-subheader>
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
                    <v-subheader class="px-0">Tên quy trình </v-subheader>
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

        <!-- Template activity add tickets-->
        <v-form v-model="valid" ref="form" lazy-validation v-if="type_activity == 'tickets'" >
            <v-layout wrap >
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Người yêu cầu </v-subheader>
                </v-flex>
                <v-flex xs12 sm10>
                    <v-select
                        v-bind:items="requestEmpItems"
                        v-model="requestEmp"
                        clearable
                        item-text="fullName"
                        item-value="employeeId"
                        autocomplete
                        return-object
                        hide-selected
                        :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
						required
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Chủ đề </v-subheader>
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
                <v-flex xs12 sm2>
                    <v-subheader class="px-0">Ngày yêu cầu </v-subheader>
                </v-flex>
                <!-- picker time -->
                <v-flex xs11 sm1>
                    <v-menu
                    ref="menuTicket1"
                    lazy
                    :close-on-content-click="false"
                    v-model="timeStartTicket"
                    
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-right="40"
                    max-width="290px"
                    min-width="290px"
                    :return-value.sync="timeTicket"
                    >
                    <v-text-field
                        slot="activator"
                        v-model="timeTicket"

                        placeholder="hh:mm"
                        readonly
                    ></v-text-field>
                    <v-time-picker v-model="timeTicket" format="24hr" @change="$refs.menuTicket1.save(timeTicket)"></v-time-picker>
                    </v-menu>
                </v-flex>
                <v-flex xs12 sm3 class="pl-0">
                    <v-menu
                    lazy
                    :close-on-content-click = "true"
                    v-model = "dueDateMenu"
                    transition = "scale-transition"
                    offset-y
                    full-width
                    :nudge-top = "40"
                    max-width = "290px"
                    min-width = "290px"
                    >
                        <v-text-field
                            slot="activator"
                            placeholder="dd/mm/yyyy"
                            v-model="dueDate"
                            @blur="dueDateMd = parseDate(dueDate)"
                            
                        ></v-text-field>
                        <v-date-picker v-model="dueDateMd" :max="startDateMax" @change="changeDate" @input="dueDate = formatDate($event)" autosave locale="vi">
                        </v-date-picker>
                    </v-menu>
                </v-flex>

                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
                    <v-subheader class="px-0">Hạn xử lý </v-subheader>
                </v-flex>
                <!-- picker time -->
                <v-flex xs11 sm1>
                    <v-menu
                    ref="menuTicket2"
                    lazy
                    :close-on-content-click="false"
                    v-model="timeEndTicket"
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-right="40"
                    max-width="290px"
                    min-width="290px"
                    :return-value.sync="timeEndTicket2"
                    >
                    <v-text-field
                        slot="activator"
                        v-model="timeEndTicket2"
                        
                        placeholder="hh:mm"
                        readonly
                    ></v-text-field>
                    <v-time-picker v-model="timeEndTicket2" format="24hr" @change="$refs.menuTicket2.save(timeEndTicket2)"></v-time-picker>
                    </v-menu>
                </v-flex>
                <v-flex xs12 sm3>
                    <v-menu
                    lazy
                    :close-on-content-click="true"
                    v-model="promulgationDateMenu"
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-top="40"
                    max-width="290px"
                    min-width="290px"
                    >
                        <v-text-field
                            slot="activator"
                            placeholder="dd/mm/yyyy"
                            v-model="promulgationDate"
                            clearable = 'true'
                            @blur="promulgationDateMd = parseDate(promulgationDate)"
                        ></v-text-field>
                        <v-date-picker v-model="promulgationDateMd" :min="endDateMin" @change="changeDate" @input="promulgationDate = formatDate($event)" autosave locale="vi">
                        </v-date-picker>
                    </v-menu>
                </v-flex>
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
                        
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
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
                        
                    ></v-select>
                </v-flex>
                <!--  -->
                <v-flex xs12 sm2 class="pl-2">
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

                valid: false,
                noteCalendard: false,
                timeStartEvent: false,
                timeEvent: null,
                timeStartTask:false,
                timeTask:null,
                timeStartTicket: false,
                timeTicket: null,
                timeEndEvent: false,
                timeEndEvent2: null,
                timeEndTask:false,
                timeEndTask2:null,
                timeEndTicket: false,
                timeEndTicket2: null,
                dueDate: '',
                dueDateMd: null,
                dueDateMenu: false,
                promulgationDate: '',
                promulgationDateMd:'',
                promulgationDateMenu: false,
                startDateMax: null,
                endDateMin:null

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
                    template: 1
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
                    axios.get( endPoint + 'employees', config)
                    .then(function (response) {
                        var serializable = response.data
                        if (serializable.hasOwnProperty('data')) {
                            for (var key in serializable.data) {
                                vm.managerItems.push({
                                    fullName: serializable.data[key].fullName,
                                    employeeId: serializable.data[key].employeeId
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

                        /* Load data đơn vị phối hợp*/
                        /*axios.get( endPoint + 'workingunits', config)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.participatorsItems.push({
                                        name: serializable.data[key].name,
                                        workingUnitId: serializable.data[key].workingUnitId
                                    })
                                    
                                }
                            }
                        })
                        .catch(function (error) {
                            console.log(error)
                        })*/
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
                            template: 1
                        };
                        const configProcessTask = {
                            params: paramsProcessTask,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };
                        /* */
                        var paramsTaskParent = {
                            type: "TASK",
                            template: 0
                        };
                        const configTaskParent = {
                            params: paramsTaskParent,
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

                        /* Load data contact*/
                        /*axios.get( endPoint + 'contacts', configContact)
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
                        })*/

                        /* Load data dự án chương trình*/

                        /*axios.get( endPoint + 'projects', configProject)
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
                        });*/
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
                /* Get API for TICKETS */
                    else if (vm.type_activity == 'tickets') {
                        var paramsTypeRequest = {
                            parent: 'TICKET'
                        };
                        const configTypeRequest = {
                            params: paramsTypeRequest,
                            headers: {
                                'groupId': vm.group_id
                            }
                        };
                        /*  */
                        var paramsProcessRequest = {
                            type: "TICKET",
                            template: 1
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

                        /* Load data người yêu cầu */
                        axios.get( endPoint + 'contacts', config)
                        .then(function (response) {
                            var serializable = response.data
                            if (serializable.hasOwnProperty('data')) {
                                for (var key in serializable.data) {
                                    vm.requestEmpItems.push({
                                        fullName: serializable.data[key].fullName,
                                        employeeId: serializable.data[key].contactId
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
                /**Get current date.time */
                var vm = this;
                var currentFullTime = new Date();
                var currentFullTimeEnd  = new Date();
                if(vm.type_activity == 'events'){
                    currentFullTimeEnd.setHours(currentFullTimeEnd.getHours() + 2);
                } else if(vm.type_activity == 'tasks' || vm.type_activity == 'tickets'){
                    currentFullTimeEnd.setHours(currentFullTimeEnd.getHours() + 24);
                };

                var currentDateStart = vm.parseCurrentDate(currentFullTime.getDate()+'/'+(currentFullTime.getMonth()+1) +'/'+currentFullTime.getFullYear());
                var currentTimeStart = vm.parseCurrentTime(currentFullTime.getHours()+':'+currentFullTime.getMinutes());
                var currentDateEnd = vm.parseCurrentDate(currentFullTimeEnd.getDate()+'/'+(currentFullTimeEnd.getMonth()+1) +'/'+currentFullTimeEnd.getFullYear());
                var currentTimeEnd = vm.parseCurrentTime(currentFullTimeEnd.getHours()+':'+currentFullTimeEnd.getMinutes());
                
                vm.dueDate = currentDateStart;
                vm.promulgationDate = currentDateEnd;
                vm.timeEvent = vm.timeTask= vm.timeTicket =  currentTimeStart;
                vm.timeEndEvent2 = vm.timeEndTask2 = vm.timeEndTicket2 = currentTimeEnd;
                /* */
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
                    if(vm.dueDate) {
                        vm.endDateMin = vm.dueDateMd
                    } else {vm.endDateMin= null};
                    if(vm.promulgationDate){
                        vm.startDateMax = vm.promulgationDateMd
                    } else {vm.startDateMax = null}
                },1000)
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
                    /*console.log(vm);
                    console.log(vm.process.activityId);
                    console.log(vm.end_point);*/
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
                            vm.participators = arrParticipators;
                            /*vm.dueDate = serializable.startDate?moment(serializable.startDate).format('DD/MM/YYYY') : null;
                            vm.promulgationDate = serializable.endDate?moment(serializable.endDate).format('DD/MM/YYYY') : null;*/
                            vm.location = {locationId:serializable.locationId,location: serializable.location, geolocation:serializable.geolocation };
                            vm.content = serializable.description;
                            vm.contact = {itemCode:serializable.contact.contactId,itemName: serializable.contact.fullname};
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
                            /*console.log('templateNo: '+ vm.templateNo);*/

                            vm.taskname = serializable.subject;
                            vm.hostingId = {workingUnitId:serializable.hostingId,name: serializable.hosting };
                            vm.manager = {employeeId:serializable.managerId,fullName: serializable.managerName };
                            vm.noteCalendard = serializable.onCalendar;
                            vm.project = {projectId:serializable.projectId,projectName: serializable.projectName};
                            vm.content = serializable.description;
                            vm.contact = {itemCode:serializable.contact.contactId,itemName: serializable.contact.fullname};
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
                            /*console.log('templateNo: '+ vm.templateNo);*/

                            vm.topicRequest = serializable.subject;
                            vm.hostingId = {workingUnitId:serializable.hostingId,name: serializable.hosting };
                            vm.requestEmp = {employeeId:serializable.contact.contactId,fullName: serializable.contact.fullName};
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
                    var startDateEvent = vm.dueDate?moment(vm.dueDate, 'DD/MM/YYYY').format('YYYYMMDD'):null;
                    var endDateEvent = vm.promulgationDate?moment(vm.promulgationDate, 'DD/MM/YYYY').format('YYYYMMDD'):null;
                    if(vm.timeEvent){
                        startDateEvent += vm.timeEvent.replace(':','')
                    }
                    if(vm.timeEndEvent2){
                       endDateEvent += vm.timeEndEvent2.replace(':','')
                    } else { endDateEvent+='0000'}

                    if(vm.manager == null){
                        vm.manager = ''
                    }
                    if(vm.contact== null){
                        vm.contact = ''
                    }
                    
                    var paramsAddEvent = new URLSearchParams()

                    paramsAddEvent.append('isTemplate', false)
                    paramsAddEvent.append('activityType', 'EVENT')
                    paramsAddEvent.append('activityCat', vm.eventType.itemCode?vm.eventType.itemCode: '')
                    paramsAddEvent.append('templateNo', vm.templateNo?vm.templateNo: '')
                    paramsAddEvent.append('onCalendar', true)
                    paramsAddEvent.append('subject', vm.topic?vm.topic:'')
                    paramsAddEvent.append('hostingId', vm.hostingId.workingUnitId?vm.hostingId.workingUnitId:'')
                    paramsAddEvent.append('hosting', vm.hostingId.name?vm.hostingId.name:'')
                    paramsAddEvent.append('managerId', vm.manager.employeeId?vm.manager.employeeId:'')
                    paramsAddEvent.append('participators', vm.participators.toString()?vm.participators.toString():'')
                    paramsAddEvent.append('startDate', startDateEvent)
                    paramsAddEvent.append('endDate', endDateEvent)
                    paramsAddEvent.append('locationId', vm.location.locationId?vm.location.locationId:'')
                    paramsAddEvent.append('location', vm.location.location?vm.location.location:'')
                    paramsAddEvent.append('geolocation', vm.location.geolocation?vm.location.geolocation:'')
                    paramsAddEvent.append('description', vm.content?vm.content:'')
                    paramsAddEvent.append('contactId', vm.contact.itemCode?vm.contact.itemCode:'')
                    
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
                    var startDateTask = vm.dueDate?moment(vm.dueDate, 'DD/MM/YYYY').format('YYYYMMDD'):'';
                    var endDateTask = vm.promulgationDate?moment(vm.promulgationDate, 'DD/MM/YYYY').format('YYYYMMDD'):'';
                    if(vm.timeTask){
                       startDateTask += vm.timeTask.replace(':','')
                    } else { startDateTask+='0000'}
                    
                    if(endDateTask){
                        if(vm.timeEndTask2){
                            endDateTask += vm.timeEndTask2
                        } else {
                            endDateTask += '0000'
                        }
                    } else {
                        endDateTask = ''
                    }

                    /** */
                    if(vm.manager == null){
                        vm.manager = ''
                    }
                    if(vm.hostingId== null){
                        vm.hostingId = ''
                    }
                    if(vm.project== null){
                        vm.project = ''
                    }
                    if(vm.contact== null){
                        vm.contact = ''
                    }
                    var paramsAddTask = new URLSearchParams()

                    paramsAddTask.append('isTemplate', false)
                    paramsAddTask.append('activityType', "TASK")
                    paramsAddTask.append('activityCat', vm.taskType.itemCode?vm.taskType.itemCode:"")
                    paramsAddTask.append('templateNo', vm.templateNo?vm.templateNo:"")
                    paramsAddTask.append('subject', vm.taskname?vm.taskname:"")
                    paramsAddTask.append('hostingId', vm.hostingId.workingUnitId?vm.hostingId.workingUnitId:"")
                    paramsAddTask.append('hosting', vm.hostingId.name?vm.hostingId.name:'')
                    paramsAddTask.append('managerId', vm.manager.employeeId?vm.manager.employeeId:"")
                    paramsAddTask.append('projectId', vm.project.projectId?vm.project.projectId:"")
                    paramsAddTask.append('onCalendar', vm.noteCalendard)
                    paramsAddTask.append('startDate', startDateTask)
                    paramsAddTask.append('endDate', endDateTask)
                    paramsAddTask.append('description', vm.content?vm.content:"")
                    paramsAddTask.append('contactId', vm.contact.itemCode?vm.contact.itemCode:"")
                    

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
                    if(vm.hostingId== null){
                        vm.hostingId = ''
                    }
                    var paramsAddProcess = new URLSearchParams()
                    
                    paramsAddProcess.append('isTemplate', true)
                    paramsAddProcess.append('activityType', vm.processType.itemCode?vm.processType.itemCode:"")
                    paramsAddProcess.append('templateNo', vm.processCode?vm.processCode:"")
                    paramsAddProcess.append('subject', vm.processName?vm.processName:"")
                    paramsAddProcess.append('hostingId', vm.hostingId.workingUnitId?vm.hostingId.workingUnitId:"")
                    paramsAddProcess.append('hosting', vm.hostingId.name?vm.hostingId.name:'')
                    
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
                    var startDateTicket = vm.dueDate?moment(vm.dueDate, 'DD/MM/YYYY').format('YYYYMMDD'):'';
                    var endDateTicket = vm.promulgationDate?moment(vm.promulgationDate, 'DD/MM/YYYY').format('YYYYMMDD'):'';
                    if(vm.timeTicket){
                       startDateTicket += vm.timeTicket.replace(':','')
                    } else { startDateTicket+='0000'}
                    
                    if(endDateTicket){
                        if(vm.timeEndTicket2){
                            endDateTicket += vm.timeEndTicket2
                        } else {
                            endDateTicket += '0000'
                        }
                    } else {
                        endDateTicket = ''
                    }

                    /** */
                    if(vm.manager == null){
                        vm.manager = ''
                    }
                    if(vm.hostingId== null){
                        vm.hostingId = ''
                    }
                    if(vm.requestEmp== null){
                        vm.requestEmp = ''
                    }
                    var paramsAddRequest = new URLSearchParams()

                    paramsAddRequest.append('isTemplate', false)
                    paramsAddRequest.append('activityType', "TICKET")
                    paramsAddRequest.append('activityCat', vm.requestType.itemCode?vm.requestType.itemCode:"")
                    paramsAddRequest.append('contactId', vm.requestEmp.employeeId?vm.requestEmp.employeeId:"")
                    paramsAddRequest.append('templateNo', vm.templateNo?vm.templateNo:"")
                    paramsAddRequest.append('subject', vm.topicRequest?vm.topicRequest:"")
                    paramsAddRequest.append('onCalendar', true)
                    paramsAddRequest.append('hostingId', vm.hostingId.workingUnitId?vm.hostingId.workingUnitId:"")
                    paramsAddRequest.append('hosting', vm.hostingId.name?vm.hostingId.name:'')
                    paramsAddRequest.append('managerId', vm.manager.employeeId?vm.manager.employeeId:"")
                    paramsAddRequest.append('startDate', startDateTicket)
                    paramsAddRequest.append('endDate', endDateTicket)
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
                if (vm.type_activity == 'events') {
                    vm.submitAddEvents()
                } else if (vm.type_activity == 'tasks') {
                    vm.submitAddTasks()
                } else if(vm.type_activity == 'process') {
                    vm.submitAddProcess()
                } else if (vm.type_activity == 'tickets') {
                    vm.submitAddRequests()
                }
                console.log(vm)
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
</style>