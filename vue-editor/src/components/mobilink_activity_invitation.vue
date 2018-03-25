<template>
    <div id="activity_invitation">
        <div style="position: relative; overflow: hidden;">
            <v-toolbar
                absolute
                color="teal lighten-3"
                dark
            >
                <div class="ml-2">Giấy mời: {{invitationCount}} ({{availableCount}} sẵn sàng)</div>
                <v-spacer></v-spacer>
                
                <v-flex v-if="permission_prop!='manager'&&permission_prop!='owner'">
                    <div class="right">
                        <v-btn icon @click="showAddNote" class="text-white mx-0">
                            <v-icon class="iconCmm">comment</v-icon>
                        </v-btn>
                        <v-btn class="mx-0" small color="success" v-on:click.stop="checkin" style="padding-left: 6px;padding-right: 6px">
                            <v-icon style="color: white" v-if="typeCheckin" >check</v-icon>
                            Sẵn sàng
                        </v-btn>
                        <v-btn small class="text-white mx-1" v-on:click.stop="checkin" color="error">
                            <v-icon style="color: white" v-if="!typeCheckin" >check</v-icon>
                            Tôi bận
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
                        <div><b>Đơn vị/ Nhóm trong cơ quan</b></div>
                        <v-btn fab small grey lighten-3 class="btn-add mx-0 my-0" v-on:click.stop="show_Add1">
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
                                        :items="itemsSelect2"
                                        v-model="select2"
                                        item-value="value"
                                        item-text="name"
                                        return-object
                                        :clearable="true"
                                        ></v-select>
                                    </v-flex>
                                    <toggle-button class="mx-1 mt-4"
                                    :value="false"
                                    v-model="presenterAddGroup"
                                    title_checked = "Thành viên"
                                    title_unchecked = "Theo dõi"
                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                    :width="50"/>
                                    <v-btn small outline color="primary" class="mx-0 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">
                                        Mời
                                    </v-btn>

                                </v-flex>
                                
                                <v-flex xs12 sm12>
                                    <v-card>
                                        <v-list >
                                            <v-list-group v-for="item in itemInvGroup" :value="item.active" v-bind:key="item.role.activityInvitationId">
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
                                                                    <v-chip label outline color="primary" class="mr-2 mt-2">{{item.role.statistic.available}}/{{item.role.statistic.invitation}}</v-chip>
                                                                    <v-btn icon title="Xóa" class="mx-0" @click.stop="updateInvitation('DELETE',item.role.activityInvitationId,index,itemInvGroup)">
                                                                        <v-icon color="red darken-3">clear</v-icon>
                                                                    </v-btn> 
                                                                </div>
                                                            </v-flex>
                                                            
                                                        </v-flex>
                                                        <v-divider xs12 class="mt-0"></v-divider>
                                                    </v-list-tile-content>
                                                    
                                                </v-list-tile>
                                                
                                                <!-- end -->

                                                    <!-- Phần thêm cá nhân trong tổ chức/ đơn vị -->
                                                    <div class="layout wrap mx-0 mb-2">
                                                        <toggle-button class="mr-1 mt-4"
                                                        :value="false"
                                                        v-model="presenterAddUserGroup"
                                                        title_checked = "Thành viên"
                                                        title_unchecked = "Theo dõi"
                                                        :labels="{checked: 'TV', unchecked: 'TD'}"
                                                        :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                        :width="50"/>
                                                        <v-flex xs12 sm8>
                                                            <v-select class="selectBoder pt-3"
                                                            placeholder="Cá nhân trong đơn vị/nhóm"
                                                            :items="itemsSelect1"
                                                            item-text="name"
                                                            item-value="value"
                                                            v-model="select1"
                                                            return-object
                                                            :clearable="true"
                                                            ></v-select>
                                                        </v-flex>
                                                        <v-btn small outline color="primary" class="mx-0 ml-1 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">
                                                            Mời
                                                        </v-btn>
                                                    </div>
                                                    <!-- end -->

                                                <!-- Phần danh sách cá nhân trong tổ chức/ đơn vị -->
                                                <v-list-tile v-for="subItem in item.items" v-bind:key="subItem.activityInvitationId">
                                                    <v-list-tile-content class="mt-2">
                                                        <v-flex xs12 class="layout wrap">
                                                            
                                                            <v-flex xs12 sm6 class="pt-1">
                                                                <v-list-tile-title>
                                                                    <toggle-button class="mr-1 mt-2" 
                                                                    @change="updatePresenterUserGroup($event,subItem.activityInvitationId,subItem)"
                                                                    :value="bindPresenter(subItem.presenter)"
                                                                     
                                                                    title_checked = "Thành viên"
                                                                    title_unchecked = "Theo dõi"
                                                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                                                    :width="50"/>

                                                                    <span class="pt-2">{{ subItem.fullName }}</span>
                                                                </v-list-tile-title>
                                                            </v-flex>

                                                            <v-flex xs12 sm6 >
                                                                <div class="right">
                                                                    <v-tooltip top>
                                                                        <v-btn icon slot="activator" class="text-white mx-0 my-0"  @click.stop="showAddNote(subItem.activityInvitationId,subItem.userNote,subItem)">
                                                                            <v-icon class="iconCmm" >comment</v-icon>
                                                                        </v-btn>
                                                                        <span>{{subItem.userNote}}</span>
                                                                    </v-tooltip>
                                                                    

                                                                    <span style="color:green" v-html="bindAvailableText(subItem.available)"></span>
                                                                
                                                                    <v-btn icon title="Xóa" class="mx-0 ml-2" @click.stop="updateInvitation('DELETE',subItem.activityInvitationId,index,item.items)">
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
                        <div><b>Cá nhân/ Tổ chức theo danh bạ</b></div>
                        <v-btn fab small grey lighten-3 class="btn-add mx-0 my-0" v-on:click.stop="show_Add2">
                            <v-icon grey darken-4>add</v-icon>
                        </v-btn>
                    </div>
                    
                    <v-card class="pl-2 pr-1">
                        <v-card-text class="px-0 pt-0">
                            <v-layout row wrap class="mx-0">
                                <v-flex class="layout wrap" v-if="showAdd2">
                                    <v-flex xs12 sm8>
                                        <v-select class="selectBoder pt-3"
                                        placeholder="Cá nhân/ tổ chức theo danh bạ"
                                        :items="itemsSelect3"
                                        v-model="select3"
                                        item-text="name"
                                        item-value="value"
                                        return-object
                                        :clearable="true"
                                        ></v-select>
                                    </v-flex>
                                    <toggle-button class="mx-1 mt-4"
                                    :value="true"
                                    v-model="presenterAddUser"
                                    title_checked = "Thành viên"
                                    title_unchecked = "Theo dõi"
                                    :labels="{checked: 'TV', unchecked: 'TD'}"
                                    :color="{checked: '#7DCE94', unchecked: '#82C7EB'}"
                                    :width="50"/>

                                    <v-btn small outline color="primary" @click="showAddCot" class="mx-0 mb-0 invBtn" style="width: 45px!important; min-width: 0px!important">
                                        Mời
                                    </v-btn>

                                    <!-- Phần dialog thêm mới liên lạc -->
                                    <v-dialog v-model="dialog_add_contact" persistent max-width="700px">
                                        <v-card>
                                            <v-card-title style="background-color: rgb(214, 233, 247)">
                                                <span>Thêm liên lạc</span>
                                            </v-card-title>

                                            <v-card-text>
                                                <jx-mobilink-activity-contact
                                                ref="activity_contact_ref"
                                                group_id="20147"
                                                end_point= "http://127.0.0.1:8081/api/" 
                                                @add-contact = 'addContact'
                                                ></jx-mobilink-activity-contact>
                                            </v-card-text>

                                            <v-card-actions>
                                                <v-spacer></v-spacer>
                                                <v-btn class="mr-3" color="primary"  @click.native="dialog_add_contact= false">Hủy</v-btn>
                                                <v-btn color="primary" @click.native="addContactInfo" >Thêm vào liên lạc</v-btn>
                                            </v-card-actions>
                                        </v-card>
                                    </v-dialog>
                                    <!-- end -->
                                </v-flex>
                                
                                <v-flex xs12 sm12>
                                    <v-card>
                                        <!-- Phần danh sách cá nhân theo danh bạ -->
                                        <v-list >
                                            <v-list-tile v-for="item in itemInvContact" v-bind:key="item.activityInvitationId">
                                                <v-list-tile-content class="mt-2">
                                                    <v-list-tile-title>
                                                        <v-flex xs12 class="layout wrap">

                                                            <v-flex xs12 sm6 class="pt-1">
                                                                <v-list-tile-title>
                                                                    <toggle-button class="mr-1 mt-2"
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
                                                                    <v-btn icon class="text-white mx-0 my-0" :title="bindTitle(item.userNote)" @click.stop="showAddNote(item.activityInvitationId,item.userNote,item)">
                                                                        <v-icon class="iconCmm" >comment</v-icon>
                                                                    </v-btn>
                                                                    <span style="color:green" v-html="bindAvailableText(item.available)"></span>
                                                                    <v-btn icon title="Xóa" class="mx-0 ml-2" @click.stop="updateInvitation('DELETE',item.activityInvitationId,index,itemInvContact)">
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
            permission_prop: null
        },

        created () {
            
        },
        
        data () {
            return {
                switch1: true,
                typeCheckin: true,
                presenterAddUser:'',
                presenterAddUserGroup:'',
                presenterAddGroup:'',
                dialog_add_note: false,
                note_text:'',
                idAddNote:'',
                indexNote:'',
                itemsNote:[],
                dialog_add_contact: false,
                showAdd1: false,
                showAdd2: false,
                /**/ 
                invitationItems:[],
                itemInvGroup:[],
                itemInvContact:[],
                invitationCount: '',
                availableCount:'',
                dataUpdateInvitation: new URLSearchParams(),
                /**/ 



                itemsSelect1: [
                    { name: 'Trịnh Công Trình', value: 1},
                    { name: 'Nguyễn Văn Thành', value: 2},
                    { name: 'Lê Tiến Hoàn', value: 3},
                ],
                select1: '',
                itemsSelect2:[
                    { name: 'Phòng Tài nguyên-Môi trường', value: 1},
                    { name: 'Bộ chỉ huy quân sự', value: 2},
                    { name: 'Phòng tư pháp', value: 3},
                ],
                select2: '',
                itemsSelect3: [
                    { name: 'Trịnh Công Trình', value: 1},
                    { name: 'Nguyễn Văn Thành', value: 2},
                    { name: 'Lê Tiến Hoàn', value: 3},
                ],
                select3: '',

            }
        },
        methods: {
            initAddActivity: function(){
                var vm = this;
                vm.itemInvGroup = [];
                vm.itemInvContact = [];
                /** */
                var paramsGetActivity = {
                    
                };
                const configGetActivity = {
                    params: paramsGetActivity,
                    headers: {
                        'groupId': vm.group_id
                    }
                };
                /* Load data invitation */
                axios.get( vm.end_point + 'activities/' + vm.class_pk + '/invitations', configGetActivity)
                .then(function (response) {
                    var serializable = response.data
                    if (serializable.hasOwnProperty('data')) {
                        vm.invitationItems = serializable.data;
                        vm.invitationCount = serializable.invitationCount;
                        vm.availableCount = serializable.availableCount;

                        for (var key in vm.invitationItems) {
                            
                            let item = vm.invitationItems[key];
                            if(item.invitationType == 0 ||item.invitationType == 1) {
                                vm.itemInvGroup.push(
                                    {
                                        "role": item,
                                        items: []
                                    }
                                )
                            } else if(item.invitationType == 2 ||item.invitationType == 4){
                                vm.itemInvContact.push(item)
                            }
                        };
                        for(var keys in vm.itemInvGroup){
                            for (var key in vm.invitationItems) {
                                let item = vm.invitationItems[key];
                                let itemGroups = vm.itemInvGroup[keys].role;
                                if(item.roleId==itemGroups.roleId&&item.invitationType==3 || item.roleId==itemGroups.roleId&&item.invitationType==5){
                                    vm.itemInvGroup[keys].items.push(item)
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
                console.log(vm)
            },
            /**Xử lý cập nhật  invitation của group và user */
            updateInvitation: function(type,invId,index,items){
                var vm = this;
                var urlUpdate = vm.end_point + "activities/"+vm.class_pk+"/invitations/"+invId;
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
                        console.log("run");
                        alert("Cập nhật dữ liệu thành công!")
                       
                    })
                    .catch(function (error) {
                        alert("Cập nhật dữ liệu thất bại!")
                    })
                } else if(type == "DELETE") {
                    axios.delete(urlUpdate, configPutInvitation)
                    .then(function (response) {
                        console.log(response);
                        items.splice(index,1);
                        alert("Xóa giấy mời thành công!")
                    })
                    .catch(function (error) {
                        console.log(error);
                        alert("Xóa giấy mời thất bại!")
                    });
                }
            },
            /**Xử lý hiển thị các trạng thái invitation */
            bindPresenter: function (item){
                if(item == 0){
                    return true
                } else {return false}
            },
            bindTitle: function(item){
                return item
            },
            bindAvailableText: function(item){
                if(item == 0) {
                    return "Chưa xác nhận"
                } else if(item == 1){return "Sẵn sàng"}
                else {return "Bận"}
            },

            /**Phần cập nhật noteUser của cá nhân */
            showAddNote: function(invId,noteText,items){
                var vm =this;
                vm.dialog_add_note = true;
                vm.note_text = noteText;
                vm.idAddNote = invId;
                vm.itemsNote = items;

            },
            submitAddNote: function(invId,note,itemsNote){
                var vm = this;
                var dataUpdateInvitation  =new URLSearchParams();
                dataUpdateInvitation.append('userNote', note);
                var urlUpdate = vm.end_point + "activities/"+vm.class_pk+"/invitations/"+invId;
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
                    itemsNote.userNote = response.data.userNote;
                    alert("Cập nhật dữ liệu thành công!");
                })
                .catch(function (error) {
                    alert("Cập nhật dữ liệu thất bại!")
                })
            },
            /**Phần cập nhật presenter */
            updatePresenterUserGroup: function(event,invId,items){
                var vm = this;
                var presenterChange;
                if(event.value == true){
                    presenterChange = 1
                }else {presenterChange = 0}
                vm.submitUpdatePresenter(invId,presenterChange,items)
            },
            submitUpdatePresenter: function(invId,presenter,items){
                var vm = this;
                var dataUpdateInvitation  =new URLSearchParams();
                dataUpdateInvitation.append('presenter', presenter);
                var urlUpdate = vm.end_point + "activities/"+vm.class_pk+"/invitations/"+invId;
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
                    
                    alert("Cập nhật dữ liệu thành công!");
                })
                .catch(function (error) {
                    
                    alert("Cập nhật dữ liệu thất bại!")
                })
            },
            /** */
            showAddCot: function(){
                var vm =this;

                vm.dialog_add_contact = true
            },
            addContact: function(){
                var vm =this;
                vm.$refs.activity_contact_ref.submitAddContact()
            },
            addContactInfo: function(data){
                var vm = this;
                if(data){
                    vm.dialog_add_contact = false;
                    alert("Thêm thành công!")
                } else {
                    alert("Thêm thất bại!")
                }
                
            },
            checkin: function(){
                var vm =this;
                vm.typeCheckin = !vm.typeCheckin;
            },
            show_Add1: function(){
                var vm =this;
                vm.showAdd1 =!vm.showAdd1
            },
            show_Add2: function(){
                var vm =this;
                vm.showAdd2 =!vm.showAdd2
            },
  
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
</style>

