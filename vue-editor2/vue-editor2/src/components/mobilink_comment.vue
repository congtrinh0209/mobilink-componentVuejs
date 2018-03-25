<template>

  <v-expansion-panel expand>
    <v-expansion-panel-content v-bind:value="expanded">
      <div slot="header">Thông tin xử lý</div>
      <v-card class="comments__container">
        <v-card-text>
          <div id="mobilink-comments-container"></div>
        </v-card-text>
      </v-card>
    </v-expansion-panel-content>
  </v-expansion-panel>

</template>

<script>
const COMPONENT_NAME = 'jx-mobilink-comment'

export default {
  name: COMPONENT_NAME,
  props: {
    id: null,
    class_pk: null,
    class_name: null,
    group_id: null,
    profilePictureURL: 'https://viima-app.s3.amazonaws.com/media/user_profiles/user-icon.png',
    textareaRows: 1,
    enableAttachments: true,
    enableHashtags: true,
    enablePinging: true,
    postCommentOnEnter: false,
    forceResponsive: false,
    readOnly: false,
    newestText: 'Mới nhất',
    oldestText: 'Cũ nhất',
    popularText: 'Phổ biến',
    attachmentsText: 'Đính kèm',
    sendText: 'Gửi',
    replyText: 'Trả lời',
    editText: 'Sửa',
    editedText: 'Đã sửa',
    youText: 'Bạn',
    saveText: 'Ghi lại',
    deleteText: 'Xóa',
    viewAllRepliesText: 'Xem tất cả câu trả lời',
    hideRepliesText: 'Ẩn câu trả lời',
    noCommentsText: 'Không có bình luận nào',
    noAttachmentsText: 'Không có tệp đính kèm',
    attachmentDropText: 'Kéo thả tệp đính kèm',
    id: 'commentId',
    parent: 'parent',
    userId: 'userId',
    created: 'createdDate',
    modified: 'modifiedDate',
    content: 'content',
    fileURL: 'fileUrl',
    fileMimeType: 'fileType',
    fileName: 'fileName',
    pings: 'pings',
    creator: 'userId',
    fullname: 'fullname',
    profileURL: 'profileUrl',
    profilePictureURL: 'pictureUrl',
    isNew: 'isNew',
    createdByAdmin: 'isAdmin',
    createdByCurrentUser: 'createdByCurrentUser',
    upvoteCount: 'upvoteCount',
    userHasUpvoted: 'userHasUpvoted',
    email: 'email',
    className: 'className',
    classPK: 'classPK',
    comments_api: '',
    expanded: true,
    user_id: 0,
    full_name: ''
  },
  created () {
    var vm = this
    const config = {
      headers: {
        'groupId': vm.group_id
      }
    }
    vm.$nextTick(function () {
      var prevewConfig = {
        profilePictureURL: vm.profilePictureURL,
        textareaRows: vm.textareaRows,
        enableAttachments: true,
        enableHashtags: vm.enableHashtags,
        enablePinging: vm.enablePinging,
        postCommentOnEnter: vm.postCommentOnEnter,
        forceResponsive: vm.forceResponsive,
        readOnly: vm.readOnly,
        newestText: vm.newestText,
        oldestText: vm.oldestText,
        popularText: vm.popularText,
        attachmentsText: vm.attachmentsText,
        sendText: vm.sendText,
        replyText: vm.replyText,
        editText: vm.editText,
        editedText: vm.editedText,
        youText: vm.youText,
        saveText: vm.saveText,
        deleteText: vm.deleteText,
        viewAllRepliesText: vm.viewAllRepliesText,
        hideRepliesText: vm.hideRepliesText,
        noCommentsText: vm.noCommentsText,
        noAttachmentsText: vm.noAttachmentsText,
        attachmentDropText: vm.attachmentDropText,
        fieldMappings: {
          id: 'commentId',
          parent: 'parent',
          userId: 'userId',
          created: 'createdDate',
          modified: 'modifiedDate',
          content: 'content',
          fileURL: 'fileUrl',
          fileMimeType: 'fileType',
          fileName: 'fileName',
          pings: 'pings',
          creator: 'userId',
          fullname: 'fullname',
          profileURL: 'profileUrl',
          profilePictureURL: 'pictureUrl',
          isNew: 'isNew',
          createdByAdmin: 'isAdmin',
          createdByCurrentUser: 'createdByCurrentUser',
          upvoteCount: 'upvoteCount',
          userHasUpvoted: 'userHasUpvoted',
          email: 'email',
          className: 'className',
          classPK: 'classPK',
        },
        timeFormatter: function(time) {
          if (time != null) {
              var dt  = time.split(/\ |\s/)
              if(dt.length == 2){
                  var d = dt[0].split(/\-|\s/)
                  return (d.slice(0,3).reverse().join('/')) + ' ' + dt[1]
              }else{
                  return time
              }
          }
          return ''
        },
        getUsers: function(onSuccess, onError) {
            onSuccess(vm.users);
            onError();
        },
        getComments: function(onSuccess, onError) {
          const config = {
            headers: {
              'groupId': vm.group_id
            }
          }
          axios.get(vm.comments_api + '/' + vm.class_name + '/' + vm.class_pk, config).then(function (response) {
            var data = [];
            if (response.hasOwnProperty('data')) {
              var serializable = response.data.data
              for (var key in serializable) {
                vm.comment = serializable[key]
                vm.formatComment(vm.comment)
                data.push(vm.comment);
              }
              onSuccess(data);
            }
          })
          .catch(function (error) {
            console.log(error)
          })  
        },
        postComment: function(data, onSuccess, onError) {
          const config = {
            headers: {
              'groupId': vm.group_id
            }
          }
          var strPings = data.pings.join();
          var params = new URLSearchParams()
          params.append('className', vm.class_name)
          params.append('classPK', vm.class_pk)
          params.append('parent', data.parent != null ? data.parent : 0)
          params.append('pings', strPings)
          params.append('content', data.content)
          params.append('upvoteCount', data.upvoteCount != null ? data.upvoteCount : 0)
          axios.post(vm.comments_api,
            params,
            config
          )
          .then(function (response) {
            if(response != null){
              vm.comment = response.data
              vm.formatComment(vm.comment)
              onSuccess(vm.comment);
            }else{
              onSuccess([]);
            }
          })
          .catch(function (error) {
            console.log(error)
          })
        },
        putComment: function(data, onSuccess, onError) {
          const config = {
            headers: {
              'groupId': vm.group_id
            }
          }
          var strPings = data.pings.join();
          var params = new URLSearchParams()
          params.append('className', vm.class_name)
          params.append('classPK', vm.class_pk)
          params.append('parent', data.parent != null ? data.parent : 0)
          params.append('pings', strPings)
          params.append('content', data.content)
          params.append('upvoteCount', data.upvoteCount != null ? data.upvoteCount : 0)
          axios.put(vm.comments_api,
            params,
            config
          )
          .then(function (response) {
            if(response != null){
              vm.comment = response.data
              vm.formatComment(vm.comment)
              onSuccess(vm.comment);
            }else{
              onSuccess([]);
            }
          })
          .catch(function (error) {
            console.log(error)
          })  
        },
        deleteComment: function(data, onSuccess, onError) {
          const config = {
            headers: {
              'groupId': vm.group_id
            }
          }
          axios.delete(vm.comments_api + '/' + data.commentId, config).then(function (response) {
            onSuccess();
          })
          .catch(function (error) {
            console.log(error)
          })  
        },
        upvoteComment: function(data, onSuccess, onError) {
          const config = {
            headers: {
              'groupId': vm.group_id
            }
          }
          if (data.userHasUpvoted) {
            var params = new URLSearchParams()
            params.append('className', vm.class_name)
            params.append('classPK', vm.class_pk)
            params.append('commentId', data.commentId)
            params.append('upvoteCount', data.upvoteCount != null ? data.upvoteCount : 0)
            axios.put(vm.comments_api + '/' + data.commentId + '/upvotes',
              params,
              config
            )
            .then(function (response) {
              if(response != null){
                vm.comment = response.data
                vm.formatComment(vm.comment)
                onSuccess(vm.comment);
              }else{
                onSuccess([]);
              }
            })
            .catch(function (error) {
              console.log(error)
            })  
          } else {
            axios.delete(vm.comments_api + '/' + data.commentId + '/upvotes', config).then(function (response) {
              vm.comment = response.data
              vm.formatComment(vm.comment)
              onSuccess(vm.comment);
            })
            .catch(function (error) {
              console.log(error)
            })  
          }
        },
        uploadAttachments: function(comments, onSuccess, onError) {
            var responses = 0;
            var successfulUploads = [];

            var serverResponded = function() {
                responses++;

                if(responses == comments.length) {
                    
                    if(successfulUploads.length == 0) {
                        onError();

                    } else {
                        onSuccess(successfulUploads)
                    }
                }
            }

            $(comments).each(function(index, comment) {
                var formData = new FormData();
                
                formData.append('file', comment.file);

                formData.append('className', vm.class_name);
                
                formData.append('classPK', vm.class_pk);
                
                formData.append('parent', comment.parent != null ? comment.parent : 0);

                formData.append('fileName', comment.file.name);
                
                formData.append('fileType', comment.file.type);
                
                formData.append('fileSize', comment.file.size);
                
                formData.append('pings', comment.pings.join());
                
                formData.append('email', vm.user_id);
                
                formData.append('fullName', vm.full_name);

                $.ajax({
                    url: '/o/v2/mobilink/comments/uploads',
                    dataType: 'json',
                    type: 'POST',
                    headers: {
                        "groupId": vm.group_id
                    },
                    data: formData,
                    cache: false,
                    contentType: false,
                    processData: false,
                    success: function(comment) {
                        comment = formatComment(comment, users);
                        successfulUploads.push(comment);
                        serverResponded();                      
                    },
                    error: function(xhr, data) {
                        serverResponded();
                    }
                });
            });
        }
      }
      vm.$emit('init-comment', prevewConfig)
    })
  },
  data () {
    return {
      users: [],
      comment: {

      }
    }
  },
  methods: {
    formatComment: function (comment) {
      var vm = this
      if(comment.parent == 0){
				vm.comment.parent = null;
			}
			
			if(comment.fileName == ''){
				vm.comment.fileName = null;
			}
			
			if(comment.fileType == ''){
				vm.comment.fileType = null;
			}
			
			if(comment.fileUrl == ''){
				vm.comment.fileUrl = null;
			}
			
			if(comment.pictureUrl == ''){
			    vm.comment.pictureUrl = null;
			}
			
			if(comment.profileUrl == ''){
          vm.comment.profileUrl = null;
      }
			
			var createdDate = new Date(vm.comment.createDate);
			
			var createdDateText = '2017-12-12 12:12';
			
			var modifiedDate = new Date(vm.comment.modifiedDate);
			
			var modifiedDateText = '2017-12-12 12:12';
			
			vm.comment.createdDate = createdDateText;
			
      vm.comment.modifiedDate = modifiedDateText;
    }
  }
}
</script>

<style>

</style>
