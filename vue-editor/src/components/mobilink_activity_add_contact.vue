<template>
    <div id="activity_add_contact">
        <!-- Template activity add events --> 
        <v-form v-model="valid" ref="form" lazy-validation >
            <v-layout wrap >
                
                <!--  -->
                <v-flex xs12 sm3 class="mt-2">
                    <v-subheader class="px-0">Tên cá nhân/ tổ chức *</v-subheader>
                </v-flex>
                <v-flex xs12 sm9>
                    <v-text-field
                        placeholder = ''
                        v-model="fullName"
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
                        v-model="email"
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
                        v-model="telNo"
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
    </div>
</template>


<script>
    const COMPONENT_NAME = 'jx-mobilink-activity-contact'

    export default {
        name: COMPONENT_NAME,
        props: {
            group_id: null,
            end_point: null,
            email_inp: null,
            dataForm: null
        },

        created () {
            
        },
        
        data () {
            return {
                fullName:'',
                email:'',
                telNo:'',
                companyName:''
            }
        },
        methods: {
            submitAddContact: function(){
                if (this.$refs.form.validate()) {
                    var vm = this;

                    const configContact = {
                        headers: {
                            'groupId': vm.group_id
                        }
                    };
                    var paramsAddContact = new URLSearchParams()

                    paramsAddContact.append('fullName', vm.fullName?vm.fullName:'')
                    paramsAddContact.append('email', vm.email?vm.email:'')
                    paramsAddContact.append('telNo', vm.telNo?vm.telNo:'')
                    paramsAddContact.append('companyName', vm.companyName?vm.companyName:'')

                    axios.post(vm.end_point + 'contacts',
                        paramsAddContact,
                        configContact
                    )
                    .then(function (response) {
                        vm.dataForm = response.data;
                        vm.$refs.form.reset();
                        vm.$emit('add-contact', vm.dataForm);
                        
                    })
                    .catch(function (error) {
                        vm.dataForm = '';
                        console.log(error);
                        vm.$emit('add-contact', vm.dataForm);
                    })
                }
                
            }
        }

    }
</script>

<style>
    
</style>

