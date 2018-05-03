<template>

    <div id="activity_invitation">
        
        <v-snackbar :timeout="3000" :top="true" :bottom="false" 
            :right="true" :left="false" :multi-line="true" 
            :vertical="false" v-model="snackbarSucc" class="snackbar-success" > 
            <v-icon flat color="white">check_circle</v-icon> 
                {{alertMess}}
            <v-btn flat fab mini color="white" @click.native="snackbarSucc = false">Tắt</v-btn> 
        </v-snackbar>
        <v-snackbar :timeout="3000" :top="true" :bottom="false" 
            :right="true" :left="false" :multi-line="true" 
            :vertical="false" v-model="snackbarErr" class="snackbar-error" > 
            <v-icon flat color="white">check_circle</v-icon> 
                {{alertMess}}
            <v-btn flat fab mini color="white" @click.native="snackbarErr = false">Tắt</v-btn> 
        </v-snackbar>
        
        <v-dialog class="application theme--light progessLoading" v-model="dialog_loading" persistent max-width="50px">
            <v-card style="text-align: center;padding-top: 5px;">
                <v-progress-circular v-bind:size="25" indeterminate color="primary"></v-progress-circular>
            </v-card>
                
        </v-dialog>

        <div style="position: relative; overflow: hidden;">
           <v-expansion-panel expand class="header-group expansion-blue">
                <v-expansion-panel-content value="true">

                    <div slot="header" class="custome-panel-heading-with-icon">
                        <div class="my-0">   
                            <div class="ml-2" style="flex: none" v-if="stateCheckin(startend_prop)==true">Giấy mời: {{availableCount}}/ {{invitationCount}} sẵn sàng</div>
                            <div class="ml-2" style="flex: none" v-if="stateCheckin(startend_prop)==false">Giấy mời: {{checkinCount}}/ {{invitationCount}} có mặt</div>
                            
                            <div style="flex: none;position:absolute;right:0;top:5px" class="ml-2">
                                <div >
                                    <span v-if="mineInv">
                                        <v-tooltip top :disabled="(userLogin.userNote?false:true)">
                                            <v-btn icon slot="activator" :class="stateCheckin(startend_prop)==false?disableClick:''" class="text-white mx-0 my-0"  @click.stop="showAddNote(userLogin)">
                                                <v-icon class="iconCmm" >comment</v-icon>
                                            </v-btn>
                                            <span>{{userLogin.userNote}}</span>
                                        </v-tooltip>
                                        
                                        <v-btn v-if="stateCheckin(startend_prop)==true" class="mx-0" small color="success" 
                                        v-on:click.stop="checkAvailable('ready',userLogin,null)" style="padding-left: 6px;padding-right: 6px"
                                        :class="activeClick?disableClick:''"
                                        >
                                            <v-icon style="color: white!important" v-if="userLogin.available == 1" >check</v-icon>
                                            <span style="color: white!important">Sẵn sàng</span>
                                        </v-btn>
                                        <v-btn v-if="stateCheckin(startend_prop)==true" small class="text-white mx-1" 
                                        v-on:click.stop="checkAvailable('busy',userLogin,null)" :class="activeClick?disableClick:''" color="error">
                                            <v-icon style="color: white!important" v-if="userLogin.available == 2" >check</v-icon>
                                            <span style="color: white!important">Tôi bận</span>
                                        </v-btn>
                                        <v-btn v-if="stateCheckin(startend_prop)==false" small class="text-white mx-1"
                                         v-on:click.stop="checkin(userLogin)" :class="disableClick" color="indigo">
                                            <v-icon style="color: white!important" v-if="userLogin.checkin" >check</v-icon>
                                            <span style="color: white!important">Tôi có mặt</span>
                                        </v-btn>
                                        
                                    </span>

                                    <v-icon title="Tải lại" @click.stop="initInvitation" class="mx-0 px-0">refresh</v-icon>

                                </div>
                                
                            </div>
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
                                        <v-btn color="darken-1" flat @click.native="dialog_add_note = false">Hủy</v-btn>
                                        <v-btn color="darken-1" flat @click.native="submitAddNote(note_text)">Lưu</v-btn>
                                    </v-card-actions>
                                </v-card>
                            </v-dialog>
                        </div>
                    </div>

                    <v-card>
                        <!-- Phần đơn vị/ Nhóm trong cơ quan-->
                        <v-expansion-panel  expand class="sub-panel">
                            <v-expansion-panel-content value="true">
                                <div slot="header" class="custome-panel-heading-with-icon mr-2 pl-0">
                                    <div class="color-subpanel">Đơn vị/ Nhóm trong cơ quan</div>
                                    
                                    <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_Add1" 
                                    v-if="managerPermision(permission_prop)&&stateEvent(startend_prop)&&showAdd1==false"
                                    grey darken-4>
                                        add_circle
                                    </v-icon>
                                    <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_Add1" 
                                    v-if="managerPermision(permission_prop)&&stateEvent(startend_prop)&&showAdd1==true"
                                    grey darken-4>
                                        do_not_disturb_on
                                    </v-icon>
                                </div>
                                
                                <v-card class="">
                                    <v-card-text class="px-0 py-0">
                                        <v-layout row wrap class="mx-0">
                                            <v-flex class="mb-3 pl-2 layout wrap" v-if="showAdd1">
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
                                            
                                            <v-flex xs12 sm12 class="wrap_invitation">
                                                <v-card>
                                                    <v-list class="py-0">
                                                        <v-list-group class="py-0" v-for="(item, index) in itemInvGroup" :value="item.active" v-bind:key="item.role.resourceInvitationId">
                                                            <!-- Phần danh sách tổ chức/ đơn vị -->
                                                            <v-list-tile slot="item" class="px-0">
                                                                <v-list-tile-content class="px-0">
                                                                    <v-flex xs12 class="layout wrap pl-2 pr-1" style="width: 100%!important">
                                                                        <v-flex xs6 sm8 class="pt-2">
                                                                            <v-list-tile-title class="item_group">
                                                                                <v-tooltip top>
                                                                                    <span slot="activator">{{ item.role.fullName }}</span>
                                                                                    <span>{{ item.role.fullName }}</span>
                                                                                </v-tooltip>
                                                                                <!-- {{ item.role.fullName }} -->
                                                                            </v-list-tile-title>
                                                                        </v-flex>
                                                                        <v-flex xs6 sm4>
                                                                            <div class="right">
                                                                                <v-chip v-if="stateEvent(startend_prop)==true" label outline color="primary" class="mr-2 mt-2">
                                                                                    {{item.role.statistic.available}}/{{item.role.statistic.invitation}}
                                                                                </v-chip>

                                                                                <v-chip v-if="stateEvent(startend_prop)==false" label outline color="primary" class="mr-2 mt-2">
                                                                                    {{item.role.statistic.checkin}}/{{item.role.statistic.invitation}}
                                                                                </v-chip>

                                                                                <v-btn icon title="Xóa" class="mx-0" v-if="managerPermision(permission_prop)==true" 
                                                                                @click.stop="updateInvitation('DELETE',item.role.resourceInvitationId,index,itemInvGroup)">
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
                                                            <div v-if="item.role.invitationType == 0 && item.leader&&stateEvent(startend_prop)" class="layout wrap mx-0 mb-2 pl-2 pr-1">
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
                                                                    item-value="userId"
                                                                    v-model="employee"
                                                                    return-object
                                                                    autocomplete
                                                                    :clearable="true"
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
                                                                </v-flex>
                                                                <v-btn @click.stop="postInvitation('UserUnit',item.role.roleId)" small outline color="primary" class="mx-0 ml-1 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">
                                                                    Mời
                                                                </v-btn>
                                                            </div>
                                                            <!-- end -->

                                                            <!-- Phần danh sách cá nhân trong tổ chức/ đơn vị -->
                                                            <v-list-tile v-for="(subItem, index) in item.items" v-bind:key="subItem.resourceInvitationId">
                                                                <v-list-tile-content class="mt-2">
                                                                    <v-flex xs12 class="layout wrap pl-2 pr-1" style="width: 100%!important">
                                                                        
                                                                        <v-flex>
                                                                            <v-list-tile-title class="pt-2">
                                                                                <toggle-button class="mr-1 mt-1" 
                                                                                @change="updatePresenterUserGroup($event,subItem.resourceInvitationId,item)"
                                                                                :value="bindPresenter(subItem.right)"
                                                                                :disabled="(managerPermision(permission_prop)==true|| item.leader)?false:true"
                                                                                title_checked = "Thành viên"
                                                                                title_unchecked = "Theo dõi"
                                                                                :labels="{checked: 'TV', unchecked: 'TD'}"
                                                                                :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                                                :width="50"/>
                                                                                <v-tooltip top>
                                                                                    <span class="pt-2" slot="activator">{{ subItem.fullName }}</span>
                                                                                    <span>Email:{{ subItem.email }} - Tel:{{ subItem.telNo }}</span>
                                                                                </v-tooltip>
                                                                                
                                                                            </v-list-tile-title>
                                                                        </v-flex>

                                                                        <v-flex class="">
                                                                            <div class="right">
                                                                                <v-tooltip top :disabled="(subItem.userNote?false:true)">
                                                                                    <v-btn icon slot="activator" :class="managerPermision(permission_prop)==false? pointerEvent : ''"
                                                                                    @click.stop="showAddNote(subItem)" class="text-white mx-0 my-0"
                                                                                    >
                                                                                        <v-icon class="iconCmm" >comment</v-icon>
                                                                                    </v-btn>
                                                                                    <span >{{subItem.userNote}}</span>
                                                                                </v-tooltip>
                                                                                
                                                                                <v-btn v-if="stateCheckin(startend_prop)==true" class="mx-0" small color="success"
                                                                                :class="managerPermision(permission_prop)==false||activeClick? pointerEvent : ''"
                                                                                
                                                                                v-on:click.stop="checkAvailable('ready',subItem,item)" style="padding-left: 6px;padding-right: 6px"
                                                                                >
                                                                                    <v-icon style="color: white" v-if="subItem.available == 1" >check</v-icon>
                                                                                    Sẵn sàng
                                                                                </v-btn>
                                                                                <v-btn v-if="stateCheckin(startend_prop)==true" small class="text-white mx-0" 
                                                                                :class="managerPermision(permission_prop)==false||activeClick? pointerEvent : ''"
                                                                                v-on:click.stop="checkAvailable('busy',subItem,item)" color="error"
                                                                                >
                                                                                    <v-icon style="color: white" v-if="subItem.available == 2" >check</v-icon>
                                                                                    Bận
                                                                                </v-btn>

                                                                                <!-- <span v-if="stateEvent(startend_prop)==true" style="color:green" class="mr-2" v-html="bindAvailableText(subItem.available)"></span> -->

                                                                                <v-btn v-if="stateCheckin(startend_prop)==false"
                                                                                :class="managerPermision(permission_prop)==false||activeClick? pointerEvent : ''"
                                                                                v-on:click.stop="managerCheckin(subItem,item)" outline small class="text-white mx-1" color="indigo"
                                                                                >
                                                                                    <v-icon color="indigo" v-if="subItem.checkin" >check</v-icon>
                                                                                    Có mặt
                                                                                </v-btn>

                                                                                <v-btn v-if="managerPermision(permission_prop)==true ||item.leader" icon title="Xóa" class="mx-0"
                                                                                @click.stop="updateInvitation('DELETE',subItem.resourceInvitationId,index,item.items)">
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
                                                    <p v-if="itemInvGroup.length == 0" class="mt-3 ml-2">Không có giấy mời</p>
                                                </v-card>
                                            </v-flex>
                                        </v-layout>
                                    </v-card-text>
                                </v-card>
                            </v-expansion-panel-content>
                        </v-expansion-panel>
                        
                        <!-- Phần cá nhân theo danh bạ -->
                        <v-expansion-panel expand class="sub-panel">
                            <v-expansion-panel-content value="true">
                                <div slot="header" class="custome-panel-heading-with-icon pl-0 mr-2">
                                    <div class="color-subpanel">Cá nhân/ Tổ chức theo danh bạ</div>

                                    <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_Add2" 
                                    v-if="managerPermision(permission_prop)&&stateEvent(startend_prop)&&showAdd2==false" grey darken-4>
                                        add_circle
                                    </v-icon>
                                    <v-icon class="btn-add mx-0 my-0" v-on:click.stop="show_Add2" 
                                    v-if="managerPermision(permission_prop)&&stateEvent(startend_prop)&&showAdd2==true"
                                    grey darken-4>
                                        do_not_disturb_on
                                    </v-icon>
                                </div>
                                
                                <v-card>
                                    <v-card-text class="px-0 py-0 pl-2 pr-1">
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
                                                                            :rules="[v => !!v || 'Trường dữ liệu bắt buộc']"
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
                                                                            :rules="[v => !!v || 'Trường dữ liệu bắt buộc']"
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
                                                    <v-list class="py-0">
                                                        <v-list-tile v-for="(item,index) in itemInvContact" v-bind:key="item.resourceInvitationId">
                                                            <v-list-tile-content>
                                                                <v-list-tile-title>
                                                                    <v-flex xs12 class="layout wrap">

                                                                        <v-flex xs6 sm5>
                                                                            <v-list-tile-title class="pt-2">
                                                                                <toggle-button class="mr-1 mt-1"
                                                                                :disabled="(managerPermision(permission_prop)==true)?false:true"
                                                                                :value="bindPresenter(item.right)"
                                                                                @change="updatePresenterUserGroup($event,item.resourceInvitationId,itemInvContact)"
                                                                                title_checked = "Thành viên"
                                                                                title_unchecked = "Theo dõi"
                                                                                :labels="{checked: 'TV', unchecked: 'TD'}"
                                                                                :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                                                :width="50"/>
                                                                                <v-tooltip top>
                                                                                    <span class="pt-2" slot="activator">{{ item.fullName }}</span>
                                                                                    <span>Email:{{ item.email }} - Tel:{{ item.telNo }}</span>
                                                                                </v-tooltip>
                                                                                
                                                                            </v-list-tile-title>
                                                                        </v-flex>
                                                                        
                                                                        <v-flex xs6 sm7>
                                                                            <div class="right">
                                                                                <v-tooltip top :disabled="(item.userNote?false:true)">
                                                                                    <v-btn icon slot="activator" :class="managerPermision(permission_prop)==false? pointerEvent : ''"
                                                                                    @click.stop="showAddNote(item)" class="text-white mx-0 my-0" 
                                                                                    >
                                                                                        <v-icon class="iconCmm" >comment</v-icon>
                                                                                    </v-btn>
                                                                                    <span >{{item.userNote}}</span>
                                                                                </v-tooltip>
                                                                                
                                                                                <v-btn v-if="stateCheckin(startend_prop)==true" class="mx-0" small color="success"
                                                                                :class="managerPermision(permission_prop)==false? pointerEvent : ''"
                                                                                v-on:click.stop="checkAvailable('ready',item,null)" style="padding-left: 6px;padding-right: 6px"
                                                                                >
                                                                                    <v-icon style="color: white" v-if="item.available == 1" >check</v-icon>
                                                                                    Sẵn sàng
                                                                                </v-btn>
                                                                                <v-btn v-if="stateCheckin(startend_prop)==true" small class="text-white mx-0" 
                                                                                :class="managerPermision(permission_prop)==false? pointerEvent : ''"
                                                                                v-on:click.stop="checkAvailable('busy',item,null)" color="error"
                                                                                >
                                                                                    <v-icon style="color: white" v-if="item.available == 2" >check</v-icon>
                                                                                    Bận
                                                                                </v-btn>

                                                                                <!-- <span v-if="stateEvent(startend_prop)==true" class="mr-2" style="color:green"
                                                                                v-html="bindAvailableText(item.available)"></span> -->

                                                                                <v-btn v-if="stateCheckin(startend_prop)==false" 
                                                                                :class="managerPermision(permission_prop)==false||activeClick? pointerEvent : ''"
                                                                                v-on:click.stop="managerCheckin(item,null)"  outline small class="text-white mx-1" color="indigo">
                                                                                    <v-icon color="indigo" v-if="item.checkin" >check</v-icon>
                                                                                    Có mặt
                                                                                </v-btn>

                                                                                <v-btn icon title="Xóa" class="mx-0" v-if="managerPermision(permission_prop)==true"
                                                                                @click.stop="updateInvitation('DELETE',item.resourceInvitationId,index,itemInvContact)">
                                                                                    <v-icon color="red darken-3">clear</v-icon>
                                                                                </v-btn> 
                                                                            </div>
                    
                                                                        </v-flex>
                                                                        
                                                                    </v-flex>
                                                                </v-list-tile-title>

                                                            </v-list-tile-content>
                                                        </v-list-tile>
                                                        
                                                    </v-list>
                                                    <!-- end -->
                                                    <p v-if="itemInvContact.length == 0" class="mt-3 ml-2">Không có giấy mời</p>
                                                </v-card>
                                            </v-flex>
                                        </v-layout>
                                    </v-card-text>
                                </v-card>
                            </v-expansion-panel-content>
                        </v-expansion-panel>

                        <!-- Phần thêm thành phần tham dự -->
                        <v-expansion-panel expand class="sub-panel">
                            <v-expansion-panel-content value="true">
                                <div slot="header" class="custome-panel-heading-with-icon pl-0 mr-2">
                                    <div class="color-subpanel">Thành phần tham dự</div>
                                    <v-icon class="btn-add mx-0 my-0" title="Sửa" v-on:click.stop="activeEdit = false" 
                                    v-if="(managerPermision(permission_prop)==true)&& activeEdit==true" grey darken-4>
                                        create
                                    </v-icon>
                                    <v-icon class="btn-add mx-0 my-0" title="Hủy" v-on:click.stop="activeEdit = true" 
                                    v-if="(managerPermision(permission_prop)==true)&&activeEdit==false" grey darken-4>
                                        cancel
                                    </v-icon>
                                </div>
                                <v-card >
                                    <v-card-text class="px-0 py-0 ">
                                        <v-form xs12 sm12 v-model="validAddInv" ref="formInvText" class="formAddInvText px-2 py-2" lazy-validation style="position: relative">
                                            <v-text-field class="py-0"
                                            placeholder="Nhập thành phần tham dự"
                                            v-model="nameInv"
                                            multi-line
                                            :readonly='activeEdit'
                                            :rules="[v => !!v || 'Nhập thành phần tham dự']"
                                            required
                                            ></v-text-field>
                                            <v-btn v-if="activeEdit == false" small outline color="blue-grey" @click="addInvText(null)">
                                                Xóa
                                            </v-btn>
                                            <v-btn class="mr-2" v-if="activeEdit == false" small outline color="blue-grey" @click="addInvText(nameInv)">
                                                Lưu
                                            </v-btn>
                                            
                                        </v-form>
                                    </v-card-text>
                                </v-card>
                            </v-expansion-panel-content>
                        </v-expansion-panel>
                        
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
            // opening_state_prop: null,
            startend_prop:null
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
                activeEdit: true,
                alertSuccess: false,
                alertError: false,
                alertMess:'',
                snackbarErr: false,
                snackbarSucc: false,
                invitationUserId:'',
                mineInv: false,
                userLogin: {},
                userIdNote:'',
                userCheck:'',
                typeAvailable: '',
                typeCheckin: false,
                contactInput:'',
                /** */
                switch1: true,
                valid: false,
                nameInv:'',
                validAddInv: false,
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
                expand_contact:true,
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
                activeClick: false,
                disableClick: 'disableClick',
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
                // vm.userId = 108;
                vm.userId = themeDisplay.getUserId();
                console.log(vm._props);
                console.log('userId:'+ vm.userId);
                vm.getInvitation();
                vm.getInvText()

            },
            /**Check permision */
            managerPermision: function(permision){
                if(permision=='manager'||permision=='hoster'||permision=='owner'||permision=='leader'){
                    return true
                } else {return false}
            },
            /*check state truyền startend*/
            stateEvent: function(startend_prop){
                if(startend_prop==0||startend_prop==1){
                    return true
                } else if(startend_prop==3||startend_prop==4) {
                    return false
                }
            },
            stateCheckin: function(startend_prop){
                if(startend_prop==0){
                    return true
                } else if(startend_prop==1||startend_prop==3||startend_prop==4) {
                    return false
                }
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
                    sort: 'createDate_Number'
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
                                vm.userLogin = item;
                                console.log('userLogin: ');
                                console.log(vm.userLogin)
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
                                if(item.roleId==itemGroups.roleId&&item.invitationType==3 || 
                                    item.roleId==itemGroups.roleId&&item.invitationType==5 || 
                                    item.roleId==itemGroups.roleId&&item.invitationType==4)
                                {
                                    vm.itemInvGroup[keys].items.push(item)
                                }
                            }
                        }
                        /**check leader */
                        for(var keys in vm.itemInvGroup){
                            for (var key in vm.invitationItems) {
                                let item = vm.invitationItems[key];
                                let itemGroups = vm.itemInvGroup[keys].role;
                                if(item.roleId==itemGroups.roleId&&item.invitationType==4&&item.mine==true ){
                                    vm.itemInvGroup[keys].user_leader = item;
                                    vm.itemInvGroup[keys].leader = true;
                                    console.log('user_leader:');
                                    console.log(vm.itemInvGroup[keys].user_leader)
                                } else{
                                    
                                }
                            }
                        };
                        // console.log(vm)
                    } else {
                        vm.invitationItems = []
                    }
                    vm.getWorkingUnit();
                    vm.getUserContact();
                    vm.getEmployees();
                })
                .catch(function (error) {
                    console.log(error.response)
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
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            if(vm.invitationItems.length!=0){
                                var itemInv = true;
                                for(var keys in vm.invitationItems){
                                    if(serializable.data[key].roleId == vm.invitationItems[keys].roleId){
                                        itemInv = false;
                                        break
                                    }
                                };
                                if(itemInv){
                                    vm.hostingIdItems.push(serializable.data[key])
                                }
                                  
                            } else{
                                vm.hostingIdItems.push(serializable.data[key])
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
                    'class': 'employee',
                    'role': vm.userLogin.roleId
                };
                const configGetEmployee = {
                    params: paramsGetEmployee,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'users', configGetEmployee)
                .then(function (response) {
                    var serializable = response.data;
                    if (serializable.hasOwnProperty('data')) {
                        for (var key in serializable.data) {
                            
                            if(vm.invitationItems.length!=0){
                                var itemInv = true;
                                for(var keys in vm.invitationItems){
                                    if(serializable.data[key].userId == vm.invitationItems[keys].toUserId){
                                        itemInv = false;
                                        break;
                                    }
                                }
                                if(itemInv){
                                    vm.employeeItems.push(serializable.data[key])
                                }
                            } else {
                                vm.employeeItems.push(
                                    serializable.data[key]
                                )
                            }
                        }
                    }
                })
                .catch(function (error) {
                    console.log(error)
                })

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
                            
                            if(vm.invitationItems.length!=0){
                                var itemInv = true;
                                for(var keys in vm.invitationItems){
                                    
                                    if(
                                        (serializable.data[key].userMappingId!=0&&serializable.data[key].userMappingId==vm.invitationItems[keys].toUserId) ||
                                        (serializable.data[key].userMappingId==0&&serializable.data[key].email==vm.invitationItems[keys].email)
                                    ){
                                        itemInv = false;
                                        break;
                                    }
                                }
                                if(itemInv){
                                    vm.contactItems.push(serializable.data[key])
                                }
                            }
                            else {
                                vm.contactItems.push(
                                    serializable.data[key]
                                )
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
                        // vm.show_alert('success','Cập nhật thành công') 
                        showMessageToastr('success', 'Cập nhật thành công')                      
                    })
                    .catch(function (error) {
                        // vm.show_alert('error','Cập nhật thất bại',error.response.data);
                        showMessageByAPICode(error.response.status, error.response.data);
                        console.log(error.response)
                    })
                } else if(type == "DELETE") {
                    axios.delete(urlUpdate, configPutInvitation)
                    .then(function (response) {
                        // items.splice(index,1);
                        setTimeout(function(){
                            vm.initInvitation();
                            // vm.show_alert('success','Xóa giấy mời thành công')  
                            showMessageToastr('success', 'Xóa giấy mời thành công')
                        },1000) ;
                        
                    })
                    .catch(function (error) {
                        // vm.show_alert('error','Xóa giấy mời thất bại',error.response.data);
                        showMessageByAPICode(error.response.status, error.response.data);
                        console.log(error.response.status);
                    });
                }
            },
            
            /**POST invitation */
            postInvitation: function(type,roleId){
                var vm = this;
                
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
                    dataPostInvitation.append('className', vm.class_name);
                    dataPostInvitation.append('classPK', vm.class_pk);
                    dataPostInvitation.append('invitationType', typeRole);
                    dataPostInvitation.append('roleId', vm.hostingId.roleId);
                    dataPostInvitation.append('fullName', vm.hostingId.roleName);
                    dataPostInvitation.append('right', presenterPostGroup);
                } 
                else if(type == 'UserUnit'&&vm.employee){
                    vm.valid = true;
                    var dataPostInvitation  =new URLSearchParams();
                    var presenterPostUserUnit;
                    if(vm.presenterAddUserUnit == true){
                        presenterPostUserUnit = 1
                    } else {presenterPostUserUnit = 0};
                    dataPostInvitation.append('className', vm.class_name);
                    dataPostInvitation.append('classPK', vm.class_pk);
                    dataPostInvitation.append('invitationType', 3);
                    dataPostInvitation.append('roleId', roleId);
                    dataPostInvitation.append('toUserId', vm.employee.userId);
                    dataPostInvitation.append('fullName', vm.employee.fullName);
                    dataPostInvitation.append('email', vm.employee.email);
                    dataPostInvitation.append('telNo', vm.employee.contactTelNo);
                    dataPostInvitation.append('right', presenterPostUserUnit);
                }
                else if(type == 'UserContact'&&vm.contact){
                    vm.valid = true;
                    var dataPostInvitation  =new URLSearchParams();
                    var presenterPostUser;
                    if(vm.presenterAddUser == true){
                        presenterPostUser = 1
                    } else {presenterPostUser = 0};
                    dataPostInvitation.append('invitationType', 2);
                    dataPostInvitation.append('className', vm.class_name);
                    dataPostInvitation.append('classPK', vm.class_pk);
                    dataPostInvitation.append('fullName', vm.contact[0].fullName);
                    dataPostInvitation.append('telNo', vm.contact[0].telNo);
                    dataPostInvitation.append('right', presenterPostUser);
                    if(vm.contact[0].userMappingId!=0){
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
                            vm.initInvitation();
                            vm.getInvText();
                            vm.dialog_loading = false;
                            // vm.show_alert('success','Thêm giấy mời thành công')
                            showMessageToastr('success', 'Thêm giấy mời thành công')
                        },2000) ;
                        vm.valid = false;
                        if(type == 'GROUP'){
                            
                            var roleAdded = vm.hostingId.roleId;
                            var hostingAfAdded = vm.hostingIdItems.filter(function(item) {
                                return item.roleId != roleAdded;
                            });
                            vm.hostingIdItems = hostingAfAdded;
                            vm.hostingId = '';
                            
                        };
                        if(type == 'UserUnit'){
                            var employeeAdded = vm.employee.employeeId;
                            var employeeAfAdded = vm.employeeItems.filter(function(item) {
                                return item.userId != employeeAdded;
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
                        // vm.show_alert('error','Thêm giấy mời thất bại',error.response.data);
                        showMessageByAPICode(error.response.status, error.response.data);
                        console.log(error.response)  
                    })
                }
                
            },
            /**Phần cập nhật noteUser của cá nhân */
            showAddNote: function(item){
                var vm =this;
                vm.dialog_add_note = true;
                vm.note_text = item.userNote;
                vm.idAddNote = item.resourceInvitationId;
                vm.itemsNote = item
            },
            submitAddNote: function(note){
                var vm = this;
                var dataUpdateInvitation  =new URLSearchParams();
                dataUpdateInvitation.append('userNote', note);
                var urlUpdate = vm.end_point + "resourceinvitations/"+vm.idAddNote;
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
                    vm.itemsNote.userNote = response.data.userNote;
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

                if(vm.managerPermision(vm.permission_prop)==true|| items.leader){
                    vm.submitUpdatePresenter(invId,presenterChange,items)
                } else {
                    return false
                }
                
            },
            submitUpdatePresenter: function(invId,presenter,items){
                var vm = this;
                var dataUpdateInvitation  =new URLSearchParams();
                dataUpdateInvitation.append('right', presenter);
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
                    // vm.show_alert('success','Cập nhật thành công')
                    showMessageToastr('success', 'Cập nhật thành công')
                    
                })
                .catch(function (error) {
                    // vm.show_alert('error','Cập nhật thất bại',error.response.data);
                    showMessageByAPICode(error.response.status, error.response.data);
                    console.log(error.response)  
                })
            },
            /* Load thành phần tham dự */
            getInvText: function(){
                var vm = this;
                var paramsGetInvText = {
                    
                };
                const configGetInvText = {
                    params: paramsGetInvText,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                axios.get( vm.end_point + 'activities/' + vm.class_pk, configGetInvText)
                .then(function (response) {
                    var serializable = response.data
                    vm.nameInv = serializable.invitation

                })
                .catch(function (error) {
                    console.log(error)
                })
            },
            /**Phần thêm thành phần tham dự */
            addInvText: function(text){
                var vm = this;
                if (this.$refs.formInvText.validate()) {
                    var dataUpdateactivity  =new URLSearchParams();
                    dataUpdateactivity.append('invitation', text);
                    var urlUpdate = vm.end_point + "activities/"+ vm.class_pk;
                    
                    const configPutInvitation = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                            
                    axios.put(urlUpdate, dataUpdateactivity, configPutInvitation)
                    .then(function (response) {
                        // vm.show_alert('success','Cập nhật thành công')
                        showMessageToastr('success', 'Cập nhật thành công');
                        vm.getInvText()
                    })
                    .catch(function (error) {
                        // vm.show_alert('error','Cập nhật thất bại',error.response.data);
                        showMessageByAPICode(error.response.status, error.response.data);
                        console.log(error.response)
                    })
                }

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
                console.log(vm);
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
                    console.log(vm);
                    vm.postInvitation('UserContact')
                };
                
            },
            /** */
            checkAvailable: function(typeCheck,subItem,item){
                var vm =this;
                vm.disableClickFunc();
                if(typeCheck == 'ready' && subItem.available!=1){
                    vm.typeAvailable = 1
                } else if(typeCheck == 'busy' && subItem.available!=2){
                    vm.typeAvailable = 2
                } else if((typeCheck == 'ready' && subItem.available==1)||(typeCheck == 'busy' && subItem.available==2)){
                    vm.typeAvailable = 0
                };

                var dataUpdateAvailable  =new URLSearchParams();
                dataUpdateAvailable.append('available', vm.typeAvailable);
                var urlUpdate = vm.end_point + "resourceinvitations/"+subItem.resourceInvitationId;
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
                    if(item == null){
                        setTimeout(function(){
                            vm.getInvitation();
                            // vm.show_alert('success','Cập nhật thành công')
                            showMessageToastr('success', 'Cập nhật thành công')

                        },1000) ;

                    } else{
                        // vm.show_alert('success','Cập nhật thành công')
                        showMessageToastr('success', 'Cập nhật thành công')
                        if(typeCheck == 'ready' && subItem.available!=1){
                            subItem.available = 1;
                            item.role.statistic.available+=1;
                            vm.availableCount+=1
                        } else if(typeCheck == 'busy' && subItem.available!=2){
                            
                            if(subItem.available==1){
                                item.role.statistic.available-=1
                                vm.availableCount-=1
                            }
                            subItem.available = 2;
                        } else if(typeCheck == 'ready' && subItem.available==1){
                            subItem.available = 0;
                            item.role.statistic.available-=1
                            vm.availableCount-=1
                        } else if(typeCheck == 'busy' && subItem.available==2){
                            subItem.available = 0;
                        };
                        
                    }
                    
                })
                .catch(function (error) {
                    // vm.show_alert('error','Cập nhật thất bại',error.response.data);
                    showMessageByAPICode(error.response.status, error.response.data);
                    console.log(error.response)
                });

            },
            checkin: function(item){
                var vm =this;
                vm.typeCheckin=!vm.typeCheckin;
                vm.disableClickFunc();
                var dataUpdateAvailable  =new URLSearchParams();
                dataUpdateAvailable.append('checkin', vm.typeCheckin);
                var urlUpdate = vm.end_point + "resourceinvitations/"+ item.resourceInvitationId;
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
                        // vm.show_alert('success','Cập nhật thành công')
                        showMessageToastr('success', 'Cập nhật thành công')
                    },1000) ;

                })
                .catch(function (error) {
                    vm.dialog_loading = true;
                    setTimeout(function(){
                        vm.getInvitation();
                        vm.dialog_loading = false;
                        // vm.show_alert('error','Cập nhật thất bại',error.response.data);
                        showMessageByAPICode(error.response.status, error.response.data);
                        console.log(error.response)
                    },1000) ;
                })
            },
            managerCheckin: function(item,itemUnit){
                var vm =this;
                vm.disableClickFunc();
                var typeCheckManager;
                typeCheckManager=!item.checkin;

                var dataUpdateAvailable  =new URLSearchParams();
                dataUpdateAvailable.append('checkin', typeCheckManager);
                var urlUpdate = vm.end_point + "resourceinvitations/"+item.resourceInvitationId;
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
                    // vm.show_alert('success','Cập nhật thành công')
                    showMessageToastr('success', 'Cập nhật thành công')
                    item.checkin = typeCheckManager;
                    if(typeCheckManager == true){
                        vm.checkinCount+=1;
                        if(itemUnit){itemUnit.role.statistic.checkin+=1}
                    } else {
                        vm.checkinCount-=1;
                        if(itemUnit){itemUnit.role.statistic.checkin-=1}
                    }
                })
                .catch(function (error) {
                    // vm.show_alert('error','Cập nhật thất bại',error.response.data);
                    showMessageByAPICode(error.response.status, error.response.data);
                    console.log(error.response)
                })
            },
            show_Add1: function(){
                var vm =this;
                vm.showAdd1 =!vm.showAdd1
            },
            show_Add2: function(){
                var vm =this;
                vm.showAdd2 =!vm.showAdd2;
            },
            show_alert: function(type,text,res){
                var vm = this;
                if(type=='success'){
                    vm.alertMess = text;
                    vm.snackbarSucc = true  
                } else {
                    var mess = notify(res);
                    if(mess){
                        vm.alertMess = mess;
                    } else {vm.alertMess = text}
                    vm.snackbarErr = true 
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
                        // vm.show_alert('error','Thêm mới liên lạc thất bại',error.response.data)
                        showMessageByAPICode(error.response.status, error.response.data);
                        console.log(error.response);
                        
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
                dataPostInvitation.append('className', vm.class_name);
                dataPostInvitation.append('classPK', vm.class_pk);
                dataPostInvitation.append('fullName', name);
                dataPostInvitation.append('telNo', tel);
                dataPostInvitation.append('email', email);
                dataPostInvitation.append('right', presenterPostUser);
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
                        vm.initInvitation();
                        vm.dialog_loading = false;
                        // vm.show_alert('success','Thêm giấy mời thành công')
                        showMessageToastr('success', 'Thêm giấy mời thành công')
                       
                    },2000) ;
                    
                })
                .catch(function (error) {
                    // vm.show_alert('error','Thêm giấy mời thất bại',error.response.data);
                    showMessageByAPICode(error.response.status, error.response.data);
                    console.log(error.response)
                });
                /*console.log("run add contact invitation")*/
            },
            disableClickFunc: function(){
                var vm = this;
                vm.activeClick = true;
                setTimeout(function(){
                    vm.activeClick = false;
                },2000)
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

    #activity_invitation nav{
        box-shadow: none!important
    }
    #activity_invitation nav .toolbar__content {
        height: 50px!important;
        /* background-color: #e1f5fe!important; */
        /* color: #0091ea!important */
    }
    #activity_invitation .formAddInvText .input-group__input{
        border: 1px solid #939393;
        border-radius: 2px;
        padding: 5px
    }
    #activity_invitation .formAddInvText button{
        float: right;
    }
    #activity_invitation .formAddInvText .input-group__details {
        display: none
    }
    #activity_invitation button{
        min-width: 0px;
        margin: 6px 0;
        text-transform: none;
    }
    #activity_invitation .disableClick{
        pointer-events: none;
    }
    #activity_invitation button .icon{
        font-size: 18px!important;
    }
    
    #activity_invitation .btn__content {
        padding-left: 0px!important;
        padding-right: 0px!important;
    }
    #activity_invitation .header-group .header__icon{
        z-index: 120;
    }

    #activity_invitation .expansion-panel__header{
        height: 50px!important;
        padding-left: 10px!important;
        padding-right: 10px!important;
    }
    #activity_invitation > div:nth-child(4) > ul > li > div.expansion-panel__header{
        padding: 0!important;
        padding-right: 5px!important
    }
    #activity_invitation .wrap_invitation ul .list--group{
        padding: 0!important;
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
    /* #activity_invitation .sub-panel .expansion-panel__header{    
        background-color: #f6f6f6!important;
    } */
    /* #activity_invitation .color-subpanel{
        color: #2a2a2a!important
    }
    #activity_invitation .sub-panel .expansion-panel__header i{
        color: #939393!important
    } */
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

    #activity_invitation .input-group .input-group--selection-controls{
        display: none!important;
    }
    #activity_invitation > div:nth-child(4) > ul > li > div.expansion-panel__header > div.header__icon{
        display: none
    }
    #activity_invitation .overlay .overlay--active{
        max-width: 100%!important;
        max-height: 100%!important
    }
</style>

