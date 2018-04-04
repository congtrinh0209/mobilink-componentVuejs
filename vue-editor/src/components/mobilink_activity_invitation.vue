<template>

    <div id="activity_invitation" v-if="opening_state_prop==1 || opening_state_prop==4 || opening_state_prop==7 " >
                
        <v-dialog class="application theme--light progessLoading" v-model="dialog_loading" persistent max-width="50px">
            <v-card>
                <v-progress-circular v-bind:size="25" indeterminate color="primary"></v-progress-circular>
            </v-card>
                
        </v-dialog>

        <v-alert type="success" icon="check_circle" class="alertInvitation" transition="slide-y-transition" v-model="alertSuccess">
            {{text_success}}
        </v-alert>
        <v-alert type="error" icon="check_circle" class="alertInvitation" transition="slide-y-transition" v-model="alertError">
            {{text_error}}
        </v-alert>
        
        <div style="position: relative; overflow: hidden;">
            <!-- <v-progress-circular v-if="loadingInv" indeterminate color="primary"></v-progress-circular> -->
            <v-toolbar
                absolute
                color="teal lighten-3"
                dark
            >   
                <div class="ml-2" v-if="opening_state_prop == 1">Giấy mời: {{invitationCount}} ({{availableCount}} sẵn sàng)</div>
                <div class="ml-2" v-if="opening_state_prop == 4">Giấy mời: {{invitationCount}} ({{checkinCount}} có mặt)</div>
                <div class="ml-2" v-if="opening_state_prop == 7 ">Giấy mời: {{invitationCount}} ({{checkinCount}} có mặt)</div>
                <v-spacer></v-spacer>
                
                <v-flex v-if="mineInv">
                    <div class="right">
                        <v-tooltip top>
                            <v-btn icon slot="activator" class="text-white mx-0 my-0"  @click.stop="showAddNote(invitationUserId,userIdNote)">
                                <v-icon class="iconCmm" >comment</v-icon>
                            </v-btn>
                            <span :v-model="userIdNote">{{userIdNote}}</span>
                        </v-tooltip>
                        
                        <v-btn v-if="opening_state_prop == 1" class="mx-0" small color="success" v-on:click.stop="checkAvailable('ready')" style="padding-left: 6px;padding-right: 6px">
                            <v-icon style="color: white" v-if="typeAvailable == 1" >check</v-icon>
                            Sẵn sàng
                        </v-btn>
                        <v-btn v-if="opening_state_prop == 1" small class="text-white mx-1" v-on:click.stop="checkAvailable('busy')" color="error">
                            <v-icon style="color: white" v-if="typeAvailable == 2" >check</v-icon>
                            Tôi bận
                        </v-btn>
                        <v-btn v-if="opening_state_prop == 4 || opening_state_prop == 7" small class="text-white mx-1" v-on:click.stop="checkin()" color="indigo">
                            <v-icon style="color: white" v-if="typeCheckin" >check</v-icon>
                            Tôi có mặt
                        </v-btn>
                        
                    </div>
                    
                </v-flex>
                <!--  -->
                <v-dialog v-model="dialog_add_note" persistent max-width="500px">
                    <v-card>
                        <v-card-text>
                            <v-container grid-list-md>
                                <v-layout wrap>
                                    <v-flex xs12>
                                        <v-text-field v-model="note_text" label="Nhập nội dung" multi-line="true"
                                            
                                        ></v-text-field>
                                    </v-flex>
                                </v-layout>
                            </v-container>
                        </v-card-text>
                        <v-card-actions>
                            <v-spacer></v-spacer>
                            <v-btn color="blue darken-1" flat @click.native="dialog_add_note = false">Hủy</v-btn>
                            <v-btn color="blue darken-1" flat @click.native="submitAddNote(idAddNote,note_text,itemsNote)">Lưu</v-btn>
                        </v-card-actions>
                    </v-card>
                </v-dialog>
            </v-toolbar>
            <!-- Phần đơn vị/ Nhóm trong cơ quan-->
            <v-expansion-panel style="padding-top:65px" expand>
                <v-expansion-panel-content value="true">
                    <div slot="header" class="custome-panel-heading-with-icon mr-2 pl-0">
                        <div>Đơn vị/ Nhóm trong cơ quan</div>
                        <v-btn fab small grey lighten-3 class="btn-add mx-0 my-0" v-on:click.stop="show_Add1" v-if="permission_prop == 'manager'|| permission_prop == 'owner'">
                            <v-icon grey darken-4>add</v-icon>
                        </v-btn>
                    </div>
                    
                    <v-card class="pl-2 pr-1">
                        <v-card-text class="px-0 py-0">
                            <v-layout row wrap class="mx-0">
                                <v-flex class="mb-3 layout wrap" v-if="showAdd1">
                                    <v-flex xs12 sm8>
                                        <v-select class="selectBoder pt-3"
                                        placeholder="Chọn đơn vị/nhóm"
                                        :items="hostingIdItems"
                                        v-model="hostingId"
                                        item-value="roleId"
                                        item-text="roleName"
                                        return-object
                                        required="true"
                                        autocomplete
                                        ></v-select>
                                    </v-flex>
                                    <toggle-button class="mx-1 mt-4"
                                    
                                    v-model="presenterAddGroup"
                                    title_checked = "Thành viên"
                                    title_unchecked = "Theo dõi"
                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                    :width="50"/>
                                    <v-btn small outline color="primary" @click.stop="postInvitation('GROUP')" class="mx-0 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">
                                        Mời
                                    </v-btn>

                                </v-flex>
                                
                                <v-flex xs12 sm12>
                                    <v-card>
                                        <v-list >
                                            <v-list-group v-for="(item, index) in itemInvGroup" :value="item.active" v-bind:key="item.role.activityInvitationId">
                                                <!-- Phần danh sách tổ chức/ đơn vị -->
                                                <v-list-tile slot="item" class="px-0">
                                                    <v-list-tile-content class="px-0">
                                                        <v-flex xs12 class="layout wrap">
                                                            <v-flex xs6 sm9 class="pt-2">
                                                                <v-list-tile-title class="item_group">
                                                                    {{ item.role.fullName }}
                                                                </v-list-tile-title>
                                                            </v-flex>
                                                            <v-flex xs6 sm3>
                                                                <div class="right">
                                                                    <v-chip v-if="opening_state_prop == 1" label outline color="primary" class="mr-2 mt-2">{{item.role.statistic.available}}/{{item.role.statistic.invitation}}</v-chip>
                                                                    <v-chip v-if="opening_state_prop == 4 || opening_state_prop == 7" label outline color="primary" class="mr-2 mt-2">{{item.role.statistic.checkin}}/{{item.role.statistic.invitation}}</v-chip>
                                                                    <v-btn icon title="Xóa" class="mx-0" v-if="permission_prop == 'manager' || permission_prop == 'owner'" 
                                                                    @click.stop="updateInvitation('DELETE',item.role.activityInvitationId,index,itemInvGroup)">
                                                                        <v-icon color="red darken-3">clear</v-icon>
                                                                    </v-btn> 
                                                                </div>
                                                            </v-flex>
                                                            
                                                        </v-flex>
                                                        <v-divider xs12 class="my-0"></v-divider>
                                                        
                                                    </v-list-tile-content>
                                                    
                                                </v-list-tile>
                                                
                                                <!-- end -->

                                                <!-- Phần thêm cá nhân trong tổ chức/ đơn vị -->
                                                <div v-if="item.role.invitationType == 0 && item.user_leader == userId" class="layout wrap mx-0 mb-2">
                                                    <toggle-button class="mr-1 mt-4"
                                                    
                                                    v-model="presenterAddUserUnit"
                                                    title_checked = "Thành viên"
                                                    title_unchecked = "Theo dõi"
                                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                    :width="50"/>
                                                    <v-flex xs12 sm8>
                                                        <v-select class="selectBoder pt-3"
                                                        placeholder="Cá nhân trong đơn vị/nhóm"
                                                        :items="employeeItems"
                                                        item-text="fullName"
                                                        item-value="employeeId"
                                                        v-model="employee"
                                                        return-object
                                                        autocomplete
                                                        :clearable="true"
                                                        ></v-select>
                                                    </v-flex>
                                                    <v-btn @click.stop="postInvitation('UserUnit')" small outline color="primary" class="mx-0 ml-1 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">
                                                        Mời
                                                    </v-btn>
                                                </div>
                                                <!-- end -->

                                                <!-- Phần danh sách cá nhân trong tổ chức/ đơn vị -->
                                                <v-list-tile v-for="(subItem, index) in item.items" v-bind:key="subItem.activityInvitationId">
                                                    <v-list-tile-content class="mt-2">
                                                        <v-flex xs12 class="layout wrap">
                                                            
                                                            <v-flex xs12 sm6 class="pt-1">
                                                                <v-list-tile-title>
                                                                    <toggle-button class="mr-1 mt-2" 
                                                                    @change="updatePresenterUserGroup($event,subItem.activityInvitationId,subItem)"
                                                                    :value="bindPresenter(subItem.presenter)"
                                                                    :disabled="(permission_prop=='manager'||permission_prop=='owner'|| item.user_leader == userId)?false:true"
                                                                    title_checked = "Thành viên"
                                                                    title_unchecked = "Theo dõi"
                                                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                                    :width="50"/>

                                                                    <span class="pt-2">{{ subItem.fullName }}</span>
                                                                </v-list-tile-title>
                                                            </v-flex>

                                                            <v-flex xs12 sm6 class="pt-1">
                                                                <div class="right">
                                                                    <v-tooltip top>
                                                                        <v-btn icon slot="activator" class="text-white mx-0 my-0" >
                                                                            <v-icon class="iconCmm" >comment</v-icon>
                                                                        </v-btn>
                                                                        <span>{{subItem.userNote}}</span>
                                                                    </v-tooltip>
                                                                    
                                                                    <span v-if="opening_state_prop == 1" style="color:green" class="mr-2" v-html="bindAvailableText(subItem.available)"></span>
                                                                    <v-btn v-if="opening_state_prop == 4 || opening_state_prop == 7"
                                                                    :class="(permission_prop!='manager'&&permission_prop!='owner')? pointerEvent : ''"
                                                                     v-on:click.stop="managerCheckin(subItem)" outline small class="text-white mx-1" color="indigo">
                                                                        <v-icon color="indigo" v-if="subItem.checkin" >check</v-icon>
                                                                        Có mặt
                                                                    </v-btn>

                                                                    <v-btn v-if="permission_prop=='manager' ||permission_prop=='owner' || item.user_leader == userId" icon title="Xóa" class="mx-0"
                                                                     @click.stop="updateInvitation('DELETE',subItem.activityInvitationId,index,item.items)">
                                                                        <v-icon color="red darken-3">clear</v-icon>
                                                                    </v-btn>
                                                                </div> 
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
            <v-divider class="my-0"></v-divider>

            <!-- Phần cá nhân theo danh bạ -->
            <v-expansion-panel expand class="mt-1">
                <v-expansion-panel-content value="true">
                    <div slot="header" class="custome-panel-heading-with-icon pl-0 mr-2">
                        <div>Cá nhân/ Tổ chức theo danh bạ</div>
                        <v-btn fab small grey lighten-3 class="btn-add mx-0 my-0" v-on:click.stop="show_Add2" v-if="permission_prop == 'manager'|| permission_prop == 'owner'">
                            <v-icon grey darken-4>add</v-icon>
                        </v-btn>
                    </div>
                    
                    <v-card class="pl-2 pr-1">
                        <v-card-text class="px-0 pt-0">
                            <v-layout row wrap class="mx-0">
                                <v-flex class="layout wrap" v-if="showAdd2">
                                    <v-flex xs12 sm8>
                                        <v-select class="selectBoder pt-3" id="selectContact"
                                        placeholder="Cá nhân/ tổ chức theo danh bạ"
                                        v-bind:items="contactItems"
                                        @input="eventInput($event)"
                                        hide-selected
                                        tags
                                        v-model="contact"
                                        item-text="fullName"
                                        item-value="contactId"
                                        return-object
                                        autocomplete
                                        clearable
                                        ></v-select>
                                    </v-flex>

                                    <toggle-button class="mx-1 mt-4"
                                    v-model="presenterAddUser"
                                    title_checked = "Thành viên"
                                    title_unchecked = "Theo dõi"
                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                    :width="50"/>

                                    <v-btn small outline color="primary" @click="addUserContact" class="mx-0 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">
                                        Mời
                                    </v-btn>

                                    <!-- Phần dialog thêm mới liên lạc postInvitation('UserContact')-->
                                    <v-dialog v-model="dialog_add_contact" persistent max-width="700px">
                                        <v-card>
                                            <v-card-title style="background-color: rgb(214, 233, 247)">
                                                <span>Thêm liên lạc</span>
                                            </v-card-title>

                                            <v-card-text>
                                                
                                                <!-- Template activity add contact --> 
                                                <v-form v-model="valid" ref="form" lazy-validation >
                                                    <v-layout wrap >
                                                        
                                                        <!--  -->
                                                        <v-flex xs12 sm3 class="mt-2">
                                                            <v-subheader class="px-0">Tên cá nhân/ tổ chức *</v-subheader>
                                                        </v-flex>
                                                        <v-flex xs12 sm9>
                                                            <v-text-field
                                                                placeholder = ''
                                                                v-model="fullNameCot"
                                                                clearable="true"
                                                                :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                                                                required
                                                            ></v-text-field>
                                                        </v-flex>
                                                        <!--  -->
                                                        <v-flex xs12 sm3 class="mt-2">
                                                            <v-subheader class="px-0">Email *</v-subheader>
                                                        </v-flex>
                                                        <v-flex xs12 sm9>
                                                            <v-text-field
                                                                placeholder = ''
                                                                v-model="emailCot"
                                                                clearable="true"
                                                                :rules="[v => !!v || 'Trường dữ liệu bắt buộc!']"
                                                                required
                                                            ></v-text-field>
                                                        </v-flex>
                                                        <!--  -->
                                                        <v-flex xs12 sm3 class="mt-2">
                                                            <v-subheader class="px-0">Số điện thoại</v-subheader>
                                                        </v-flex>
                                                        <v-flex xs12 sm9>
                                                            <v-text-field
                                                                placeholder = ''
                                                                v-model="telNoCot"
                                                                clearable="true"
                                                            ></v-text-field>
                                                        </v-flex>
                                                        <!--  -->
                                                        <v-flex xs12 sm3 class="mt-2">
                                                            <v-subheader class="px-0">Cơ quan/ địa chỉ</v-subheader>
                                                        </v-flex>
                                                        <v-flex xs12 sm9>
                                                            <v-text-field
                                                                placeholder = ''
                                                                v-model="companyName"
                                                                clearable="true"
                                                            ></v-text-field>
                                                        </v-flex>
                                                        
                                                    </v-layout>
                                                </v-form>
                                                <!-- end -->
                                            </v-card-text>

                                            <v-card-actions>
                                                <v-spacer></v-spacer>
                                                <v-btn class="mr-3" color="primary"  @click.native="dialog_add_contact= false">Hủy</v-btn>
                                                <v-btn color="primary" @click.native="submitAddContact" >Thêm vào liên lạc</v-btn>
                                            </v-card-actions>
                                        </v-card>
                                    </v-dialog>
                                    <!-- end -->
                                </v-flex>
                                
                                <v-flex xs12 sm12>
                                    <v-card>
                                        <!-- Phần danh sách cá nhân theo danh bạ -->
                                        <v-list >
                                            <v-list-tile v-for="(item,index) in itemInvContact" v-bind:key="item.activityInvitationId">
                                                <v-list-tile-content class="mt-2">
                                                    <v-list-tile-title>
                                                        <v-flex xs12 class="layout wrap">

                                                            <v-flex xs12 sm6 class="pt-1">
                                                                <v-list-tile-title>
                                                                    <toggle-button class="mr-1 mt-2"
                                                                    :disabled="(permission_prop=='manager'||permission_prop=='owner')?false:true"
                                                                    :value="bindPresenter(item.presenter)"
                                                                    @change="updatePresenterUserGroup($event,item.activityInvitationId,item)"
                                                                    title_checked = "Thành viên"
                                                                    title_unchecked = "Theo dõi"
                                                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                                    :width="50"/>
                                                                    <span class="pt-2">{{ item.fullName }}</span>
                                                                </v-list-tile-title>
                                                            </v-flex>
                                                            
                                                            <v-flex xs12 sm6>
                                                                <div class="right">
                                                                    <v-tooltip top>
                                                                        <v-btn icon slot="activator" class="text-white mx-0 my-0" >
                                                                            <v-icon class="iconCmm" >comment</v-icon>
                                                                        </v-btn>
                                                                        <span>{{item.userNote}}</span>
                                                                    </v-tooltip>
                                                                    
                                                                    <span v-if="opening_state_prop == 1" class="mr-2" style="color:green" v-html="bindAvailableText(item.available)"></span>

                                                                    <v-btn v-if="opening_state_prop == 4 || opening_state_prop == 7" 
                                                                    :class="(permission_prop!='manager'&&permission_prop!='owner')? pointerEvent : ''"
                                                                    v-on:click.stop="managerCheckin(item)"  outline small class="text-white mx-1" color="indigo">
                                                                        <v-icon color="indigo" v-if="item.checkin" >check</v-icon>
                                                                        Có mặt
                                                                    </v-btn>

                                                                    <v-btn icon title="Xóa" class="mx-0" v-if="permission_prop == 'manager'|| permission_prop == 'owner'"
                                                                     @click.stop="updateInvitation('DELETE',item.activityInvitationId,index,itemInvContact)">
                                                                        <v-icon color="red darken-3">clear</v-icon>
                                                                    </v-btn> 
                                                                </div>
           
                                                            </v-flex>
                                                            
                                                        </v-flex>
                                                    </v-list-tile-title>

                                                    <v-divider class="mt-0"></v-divider>
                                                </v-list-tile-content>  
                                            </v-list-tile>
                                            
                                        </v-list>
                                        <!-- end -->
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
    const COMPONENT_NAME = 'jx-mobilink-activity-invitation'

    export default {
        name: COMPONENT_NAME,
        props: {
            id: null,
            class_pk: null,
            class_name: null,
            group_id: null,
            end_point: null,
            working_unit_prop: null,
            permission_prop: null,
            opening_state_prop: null
        },

        created () {
            var vm = this
            vm.$nextTick(function () {
                vm.initInvitation()
            })
        },
        
        data () {
            return {
                userId: '',
                alertSuccess: false,
                alertError: false,
                invitationUserId:'',
                mineInv: false,
                userIdNote:'',
                userCheck:'',
                typeAvailable: '',
                typeCheckin: false,
                contactInput:'',
                /** */
                switch1: true,
                valid: false,
                presenterAddUser:'',
                presenterAddUserUnit:'',
                presenterAddGroup:'',
                dialog_add_note: false,
                note_text:'',
                idAddNote:'',
                indexNote:'',
                itemsNote:[],
                dialog_add_contact: false,
                showAdd1: false,
                showAdd2: false,
                disUserMail: false,
                /**/ 
                invitationItems:[],
                itemInvGroup:[],
                itemInvContact:[],
                contactItems:[],
                contact:'',
                invitationCount: 0,
                availableCount: 0,
                checkinCount:0,
                dataUpdateInvitation: new URLSearchParams(),
                /**/ 
                hostingIdItems:[],
                hostingId:'',
                employeeItems:[],
                employee:'',
                roleIdUser:'',
                text_error:'Cập nhật thất bại',
                text_success:'Cập nhật thành công',
                pointerEvent: 'pointerEvent',
                dialog_loading: false,
                // 
                fullNameCot:'',
                emailCot:'',
                telNoCot:'',
                companyName:''
            }
        },
        methods: {
            
            initInvitation: function(){
                var vm = this;
                /*vm.userId = 108;*/
                vm.userId = themeDisplay.getUserId();
                Promise.all([vm.getInvitation(),vm.activeGetEmployees()]).then(function() {
                    vm.getWorkingUnit();
                    vm.getUserContact();
                    vm.getEmployees()
                }, function() {
                    console.log("error")
                });
                
                /*vm.getWorkingUnit();
                vm.getUserContact();
                vm.getInvitation(); 
                setTimeout(function(){
                    vm.activeGetEmployees();
                },4000);*/
                console.log(vm._props);
                console.log('userId:'+ vm.userId)
            },
            /* Load data invitation */
            getInvitation: function(){
                /*console.log("getInvitation");*/
                var vm = this;
                vm.presenterAddGroup = false;
                vm.presenterAddUser = false;
                vm.presenterAddUserUnit = false;
                vm.itemInvGroup = [];
                vm.itemInvContact = [];

                var paramsGetInvitation = {
                    
                };
                const configGetInvitation = {
                    params: paramsGetInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                
                axios.get( vm.end_point + 'resourceinvitations/'+vm.class_name+'/' + vm.class_pk, configGetInvitation)
                .then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        vm.invitationItems = serializable.data;
                        vm.invitationCount = serializable.invitationCount;
                        vm.availableCount = serializable.availableCount;
                        vm.checkinCount = serializable.checkinCount;

                        for (var key in vm.invitationItems) {
                            
                            let item = vm.invitationItems[key];
                            /**check mine */
                            if(item.mine == true){
                                vm.mineInv = true;
                                vm.userIdNote = item.userNote;
                                vm.invitationUserId = item.activityInvitationId;
                                vm.typeAvailable = item.available;
                                vm.typeCheckin = item.checkin
                            }
                            /** push đơn vị, nhóm*/
                            if(item.invitationType == 0 ||item.invitationType == 1) {
                                vm.itemInvGroup.push(
                                    {
                                        "role": item,
                                        items: []
                                    }
                                )
                            } else if(item.invitationType == 2){
                                vm.itemInvContact.push(item)
                            }
                        };
                        /**push cá nhân trong đơn vị */
                        for(var keys in vm.itemInvGroup){
                            for (var key in vm.invitationItems) {
                                let item = vm.invitationItems[key];
                                let itemGroups = vm.itemInvGroup[keys].role;
                                if(item.roleId==itemGroups.roleId&&item.invitationType==3 || item.roleId==itemGroups.roleId&&item.invitationType==5 || item.roleId==itemGroups.roleId&&item.invitationType==4){
                                    vm.itemInvGroup[keys].items.push(item)
                                }
                            }
                        }
                        /**check leader */
                        for(var keys in vm.itemInvGroup){
                            for (var key in vm.invitationItems) {
                                let item = vm.invitationItems[key];
                                let itemGroups = vm.itemInvGroup[keys].role;
                                if(item.roleId==itemGroups.roleId&&item.invitationType==4 ){
                                    vm.itemInvGroup[keys].user_leader = item.toUserId
                                } else{
                                    
                                }
                            }
                        }
                        
                    } else {
                        vm.invitationItems = []
                    }
                    
                })
                .catch(function (error) {
                    console.log(error)
                })
                /** */
            },
            
            /**Xử lý hiển thị các trạng thái invitation */
            bindPresenter: function (item){
                if(item == 0){
                    return false
                } else {return true}
            },

            bindAvailableText: function(item){
                if(item == 0) {
                    return "Chưa xác nhận"
                } else if(item == 1){return "Sẵn sàng"}
                else{
                    return "Bận"
                }
                
            },
            /**get workingUnit */
            getWorkingUnit: function(){
                /*console.log("getWorkingUnit");*/
                var vm = this;
                var paramsGetWorkingUnit = {
                    full: true
                };
                const configGetWorkingUnit = {
                    params: paramsGetWorkingUnit,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'resourceroles/'+vm.class_name+'/'+vm.class_pk, configGetWorkingUnit)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            for(var keys in vm.invitationItems){
                                if(serializable.data[key].roleId == vm.invitationItems[keys].roleId){
                                    vm.hostingIdItems.push(
                                        serializable.data[key]
                                    );
                                    break;
                                    
                                }
                            }
                            
                        }
                    };
                    /*console.log(vm)*/
                })
                .catch(function (error) {
                    console.log(error)
                })
                
            },
            /**get employee */
            getEmployees: function(){
                var vm = this;
                var paramsGetEmployee = {
                    'workingunit': vm.working_unit_prop,
                    'active': true
                };
                const configGetEmployee = {
                    params: paramsGetEmployee,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'employees', configGetEmployee)
                .then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            for(var keys in vm.invitationItems){
                                if(serializable.data[key].mappingUser.userId == vm.invitationItems[keys].toUserId){
                                    vm.employeeItems.push(
                                        serializable.data[key]
                                    )
                                    break;
                                }
                            }
  
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })

            },
            /**run get employees */
            activeGetEmployees: function(){
                /*console.log("activeGetEmployees");*/
                var vm = this;
                for(var keys in vm.itemInvGroup){
                    if(vm.itemInvGroup[keys].user_leader&&vm.itemInvGroup[keys].user_leader == vm.userId){
                        vm.roleIdUser = vm.itemInvGroup[keys].role.roleId;
                        
                    }
                }
            },
            /**get contact */
            getUserContact: function(){
                /*console.log("getUserContact");*/
                var vm = this;
                var paramsGetUserContact = {
                    
                };
                const configGetWorkingUnit = {
                    params: paramsGetUserContact,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'contacts', configGetWorkingUnit)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            for(var keys in vm.invitationItems){
                                if(serializable.data[key].userMappingId == vm.invitationItems[keys].toUserId){
                                    vm.contactItems.push(
                                        serializable.data[key]
                                    )
                                    break;
                                }
                            }
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })

            },
            
            /**Xử lý cập nhật  invitation của group và user */
            updateInvitation: function(type,invId,index,items){
                var vm = this;
                
                var urlUpdate = vm.end_point + "resourceinvitations/"+invId;
                var paramsPutInvitation = {
                    
                };
                const configPutInvitation = {
                    params: paramsPutInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                var postData = vm.dataUpdateInvitation;		
                		
                if(type == "PUT"){
                    axios.put(urlUpdate, postData, configPutInvitation)
                    .then(function (response) {
                        vm.show_alert('success','Cập nhật thành công')
                       
                    })
                    .catch(function (error) {
                        vm.show_alert('error','Cập nhật thất bại')
                    })
                } else if(type == "DELETE") {
                    axios.delete(urlUpdate, configPutInvitation)
                    .then(function (response) {
                        items.splice(index,1);
                        vm.show_alert('success','Xóa giấy mời thành công')
                    })
                    .catch(function (error) {
                        
                        vm.show_alert('error','Xóa giấy mời thất bại')
                    });
                }
            },
            
            /**POST invitation */
            postInvitation: function(type){
                var vm = this;
                /*console.log(vm);*/
                if(type == 'GROUP'&&vm.hostingId){
                    vm.valid = true;
                    var dataPostInvitation  =new URLSearchParams();
                    var presenterPostGroup;
                    var typeRole;
                    if(vm.presenterAddGroup == true){
                        presenterPostGroup = 1
                    } else {presenterPostGroup = 0};
                    if(vm.hostingId.type == "workingunit"){
                        typeRole = 0
                    }else if(vm.hostingId.type == "jobpos"){
                        typeRole = 1
                    };
                    dataPostInvitation.append('invitationType', typeRole);
                    dataPostInvitation.append('roleId', vm.hostingId.roleId);
                    dataPostInvitation.append('fullName', vm.hostingId.roleName);
                    dataPostInvitation.append('presenter', presenterPostGroup);
                } 
                else if(type == 'UserUnit'&&vm.employee){
                    vm.valid = true;
                    var dataPostInvitation  =new URLSearchParams();
                    var presenterPostUserUnit;
                    if(vm.presenterAddUserUnit == true){
                        presenterPostUserUnit = 1
                    } else {presenterPostUserUnit = 0};
                    
                    dataPostInvitation.append('invitationType', 3);
                    dataPostInvitation.append('roleId', vm.roleIdUser);
                    dataPostInvitation.append('toUserId', vm.employee.mappingUser.userId);
                    dataPostInvitation.append('fullName', vm.employee.fullName);
                    dataPostInvitation.append('email', vm.employee.email);
                    dataPostInvitation.append('telNo', vm.employee.telNo);
                    dataPostInvitation.append('presenter', presenterPostUserUnit);
                }
                else if(type == 'UserContact'&&vm.contact){
                    vm.valid = true;
                    var dataPostInvitation  =new URLSearchParams();
                    var presenterPostUser;
                    if(vm.presenterAddUser == true){
                        presenterPostUser = 1
                    } else {presenterPostUser = 0};
                    dataPostInvitation.append('invitationType', 2);
                    dataPostInvitation.append('fullName', vm.contact[0].fullName);
                    dataPostInvitation.append('telNo', vm.contact[0].telNo);
                    dataPostInvitation.append('presenter', presenterPostUser);
                    if(vm.contact.userMappingId){
                        dataPostInvitation.append('toUserId', vm.contact[0].userMappingId);
                    } else {
                        dataPostInvitation.append('email', vm.contact[0].email);
                    }
                }
                
                var urlUpdate = vm.end_point + "resourceinvitations";
                var paramsPostInvitation = {
                    
                };
                const configPostInvitation = {
                    params: paramsPostInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                if(vm.valid){
                    axios.post(urlUpdate, dataPostInvitation, configPostInvitation)
                    .then(function (response) {
                        vm.dialog_loading = true;
                        setTimeout(function(){
                            vm.getInvitation();
                            vm.dialog_loading = false;
                            vm.show_alert('success','Thêm giấy mời thành công');
                        },3000) ;
                        vm.valid = false;
                        if(type == 'GROUP'){
                            var roleAdded = vm.hostingId.roleId;
                            var hostingAfAdded = vm.hostingIdItems.filter(function(item) {
                                return item.roleId != roleAdded;
                            });
                            vm.hostingIdItems = hostingAfAdded;
                            vm.hostingId = '';
                            setTimeout(function(){
                                vm.activeGetEmployees();
                            },4000);
                        };
                        if(type == 'UserUnit'){
                            var employeeAdded = vm.employee.employeeId;
                            var employeeAfAdded = vm.employeeItems.filter(function(item) {
                                return item.employeeId != employeeAdded;
                            });
                            vm.employeeItems = employeeAfAdded;
                            vm.employee = ''
                        };
                        if(type == 'UserContact'){
                            var contactAdded = vm.contact[0].contactId.contactId;
                            var contactAfAdded = vm.contactItems.filter(function(item) {
                                return item.contactId != contactAdded;
                            });
                            vm.contactItems = contactAfAdded;
                            vm.contact = [];
                        };
                        
                        
                    })
                    .catch(function (error) {
                        vm.show_alert('error','Thêm giấy mời thất bại')
                    })
                }
                
            },
            /**Phần cập nhật noteUser của cá nhân */
            showAddNote: function(invId,noteText,items){
                var vm =this;
                vm.dialog_add_note = true;
                vm.note_text = noteText;
                vm.idAddNote = invId;
                
            },
            submitAddNote: function(invId,note,itemsNote){
                var vm = this;
                var dataUpdateInvitation  =new URLSearchParams();
                dataUpdateInvitation.append('userNote', note);
                var urlUpdate = vm.end_point + "resourceinvitations/"+invId;
                var paramsPutInvitation = {
                    
                };
                const configPutInvitation = {
                    params: paramsPutInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.put(urlUpdate, dataUpdateInvitation, configPutInvitation)
                .then(function (response) {
                    vm.dialog_add_note = false;
                    vm.userIdNote = response.data.userNote;
                    
                })
                .catch(function (error) {
                    
                })
            },
            /**Phần cập nhật presenter */
            updatePresenterUserGroup: function(event,invId,items){
                var vm = this;
                var presenterChange;
                if(event.value == true){
                    presenterChange = 1
                }else {presenterChange = 0};
                vm.submitUpdatePresenter(invId,presenterChange,items)
            },
            submitUpdatePresenter: function(invId,presenter,items){
                var vm = this;
                var dataUpdateInvitation  =new URLSearchParams();
                dataUpdateInvitation.append('presenter', presenter);
                var urlUpdate = vm.end_point + "resourceinvitations/"+invId;
                var paramsPutInvitation = {
                    
                };
                const configPutInvitation = {
                    params: paramsPutInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.put(urlUpdate, dataUpdateInvitation, configPutInvitation)
                .then(function (response) {
                    vm.show_alert('success','Cập nhật thành công')
                })
                .catch(function (error) {
                    vm.show_alert('error','Cập nhật thất bại')
                })
            },
            /** */
            showAddCot: function(){
                var vm =this;

                vm.dialog_add_contact = true
            },
            eventInput: function(event){
                var vm = this;
                /*console.log(event);*/
                vm.contact = [];
                /*console.log("run input");*/
                setTimeout(function(){
                    if(event.length!=0){
                        vm.contact = [event[event.length -1]];
                    }else {vm.contact= []}            
                },200)
            },
            addUserContact:function(){
                var vm = this;
                
                var contactList = vm.contactItems;
                var checkContact = true;
                for(var key in contactList){
                    if(typeof(vm.contact[0]) == 'object'){
                        if(vm.contact[0].contactId == contactList[key].contactId){
                            checkContact = false;
                        }
                    } 
                    
                };
                if(checkContact){
                    setTimeout(function(){
                        vm.dialog_add_contact = true;
                        setTimeout(function(){
                            vm.fullNameCot = vm.contact[0];
                        },100);
                    },200)
                } else {
                    vm.postInvitation('UserContact')
                };
                
            },
            /** */
            checkAvailable: function(typeCheck){
                var vm =this;
                if(typeCheck == 'ready'){
                    vm.typeAvailable = 1
                } else if(typeCheck == 'busy'){
                    vm.typeAvailable = 2
                };

                var dataUpdateAvailable  =new URLSearchParams();
                dataUpdateAvailable.append('available', vm.typeAvailable);
                var urlUpdate = vm.end_point + "resourceinvitations/"+vm.invitationUserId;
                var paramsPutInvitation = {
                    
                };
                const configPutInvitation = {
                    params: paramsPutInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.put(urlUpdate, dataUpdateAvailable, configPutInvitation)
                .then(function (response) {
                    vm.dialog_loading = true;
                    setTimeout(function(){
                        vm.getInvitation();
                        vm.dialog_loading = false;
                        vm.show_alert('success','Cập nhật thành công');
                    },1000) ;
                    
                })
                .catch(function (error) {
                    vm.dialog_loading = true;
                    setTimeout(function(){
                        vm.getInvitation();
                        vm.dialog_loading = false;
                        vm.show_alert('error','Cập nhật thất bại');
                    },1000) ;
                });

            },
            checkin: function(){
                var vm =this;
                vm.typeCheckin=!vm.typeCheckin;

                var dataUpdateAvailable  =new URLSearchParams();
                dataUpdateAvailable.append('checkin', vm.typeCheckin);
                var urlUpdate = vm.end_point + "resourceinvitations/"+vm.invitationUserId;
                var paramsPutInvitation = {
                    
                };
                const configPutInvitation = {
                    params: paramsPutInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.put(urlUpdate, dataUpdateAvailable, configPutInvitation)
                .then(function (response) {
                    vm.dialog_loading = true;
                    setTimeout(function(){
                        vm.getInvitation();
                        vm.dialog_loading = false;
                        vm.show_alert('success','Cập nhật thành công');
                    },1000) ;

                })
                .catch(function (error) {
                    vm.dialog_loading = true;
                    setTimeout(function(){
                        vm.getInvitation();
                        vm.dialog_loading = false;
                        vm.show_alert('success','Cập nhật thất bại');
                    },1000) ;
                })
            },
            managerCheckin: function(item){
                var vm =this;
                var typeCheckManager;
                typeCheckManager=!item.checkin;

                var dataUpdateAvailable  =new URLSearchParams();
                dataUpdateAvailable.append('checkin', typeCheckManager);
                var urlUpdate = vm.end_point + "resourceinvitations/"+item.activityInvitationId;
                var paramsPutInvitation = {
                    
                };
                const configPutInvitation = {
                    params: paramsPutInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.put(urlUpdate, dataUpdateAvailable, configPutInvitation)
                .then(function (response) {
                    item.checkin = typeCheckManager;
                    if(typeCheckManager == true){
                        vm.checkinCount+=1;
                    } else {vm.checkinCount-=1;}
                    
                    vm.show_alert('success','Cập nhật thành công')
                })
                .catch(function (error) {
                    vm.show_alert('error','Cập nhật thất bại')
                })
            },
            show_Add1: function(){
                var vm =this;
                vm.showAdd1 =!vm.showAdd1
            },
            show_Add2: function(){
                var vm =this;
                vm.showAdd2 =!vm.showAdd2
            },
            show_alert: function(type,text){
                var vm = this;
                if(type=='success'){
                    vm.text_success = text;
                    vm.alertSuccess = true;
                    setTimeout(function(){vm.alertSuccess = false},2000)
                } else {
                    vm.text_error = text;
                    vm.alertError = true;
                    setTimeout(function(){vm.alertError = false},2000)
                }
            },
            submitAddContact: function(){
                if (this.$refs.form.validate()) {
                    var vm = this;

                    const configContact = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                    var paramsAddContact = new URLSearchParams()

                    paramsAddContact.append('fullName', vm.fullNameCot?vm.fullNameCot:'')
                    paramsAddContact.append('email', vm.emailCot?vm.emailCot:'')
                    paramsAddContact.append('telNo', vm.telNoCot?vm.telNoCot:'')
                    paramsAddContact.append('companyName', vm.companyName?vm.companyName:'')
                    paramsAddContact.append('contactType', 0)
                    axios.post(vm.end_point + 'contacts',
                        paramsAddContact,
                        configContact
                    )
                    .then(function (response) {
                        vm.contact = '';
                        vm.$refs.form.reset();
                        vm.dialog_add_contact = false;
                        var serializable = response.data;
                        
                        var nameRes = serializable.fullName;
                        var emailRes = serializable.email;
                        var telRes = serializable.telNo;
                        vm.addInvitationCotEmail(nameRes,telRes,emailRes);
                        /*console.log("run success add contact")*/
                        
                    })
                    .catch(function (error) {
                        
                        console.log(error);
                        
                    })
                }
                
            },
            addInvitationCotEmail: function(name,tel,email){
                var vm = this;
                var urlUpdate = vm.end_point + "resourceinvitations";
                var dataPostInvitation  =new URLSearchParams();
                var presenterPostUser;
                if(vm.presenterAddUser == true){
                    presenterPostUser = 1
                } else {presenterPostUser = 0};
                dataPostInvitation.append('invitationType', 2);

                dataPostInvitation.append('fullName', name);
                dataPostInvitation.append('telNo', tel);
                dataPostInvitation.append('email', email);
                dataPostInvitation.append('presenter', presenterPostUser);
                var paramsPostInvitation = {
                    
                };
                const configPostInvitation = {
                    params: paramsPostInvitation,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.post(urlUpdate, dataPostInvitation, configPostInvitation)
                .then(function (response) {
                    vm.dialog_loading = true;
                    setTimeout(function(){
                        vm.getInvitation();
                        vm.dialog_loading = false;
                        vm.show_alert('success','Thêm mới giấy mời thành công');
                    },3000) ;
                    
                })
                .catch(function (error) {
                    vm.show_alert('error','Thêm mới giấy mời thất bại')
                });
                /*console.log("run add contact invitation")*/
            }
        }

    }
</script>

<style>
    .custome-panel-heading-with-icon {
	    display: -webkit-flex; /* Safari */
	    -webkit-align-items: center; /* Safari 7.0+ */
	    display: flex;
	    align-items: center;
	}
	.custome-panel-heading-with-icon div {
	   -webkit-flex: 1; /* Safari 6.1+ */
	   flex: 1;
	}
    #activity_invitation .alertInvitation{
        width: 30%!important;
        height: 75px!important;
        min-width: 300px!important;
        z-index: 122!important;
        position: fixed;
        top: 0;
        left: 50%;
        transform: translate(-50%, 0);
    }
    #activity_invitation .toolbar__title{
        font-size: 13px!important;
    }
    #activity_invitation .btn__content {
        padding-left: 0px!important;
        padding-right: 0px!important;
    }
    #activity_invitation .expansion-panel__header{
        padding-left: 10px!important;
        padding-right: 10px!important;
    }
    #activity_invitation .list__tile{
        padding: 0!important;
    }
    #activity_invitation .list__tile__title{

        height: 100%!important;
    }
    #activity_invitation .list__tile__content{
        overflow: visible!important;
    }
    #activity_invitation .item_group:hover{
        color: blue;
        cursor: pointer;
    }
    #activity_invitation .chip {
        max-height: 30px!important
    }
    #activity_invitation .selectBoder .input-group__input{
        border: 1px solid #1976D2 ;
        border-radius: 4px;
        padding-left: 8px;
    }
    #activity_invitation .selectBoder .input-group__details {
        display: none
    }
    #activity_invitation  .iconCmm {
        color: #1976D2
    }
    #activity_invitation .invBtn{
        margin-top: 19px!important;
    }
    #activity_invitation .btn-add{
        width: 30px;
        height: 30px;
    }
    #activity_invitation .tooltip{
        opacity: 1!important;
        z-index: 0
    }
    .pointerEvent{
        pointer-events: none!important
    }
    #activity_invitation .progessLoading{
        text-align: center
    }
    #activity_invitation .input-group .input-group--selection-controls{
        display: none!important;
    }
    
</style>

