<template>
<div :id="'calendar_'+id">
    <v-container grid-list-md text-xs-center>
        {{message}}
    </v-container>
</div>
</template>

<script>
const COMPONENT_NAME = 'jx-mobilink-calendar'

export default {
  name: COMPONENT_NAME,
  props: {
    id: null,
    class_pk: null,
    class_name: null,
    group_id: null
  },
  created () {
    var vm = this
    const config = {
      headers: {
        'groupId': vm.group_id
      }
    }
    vm.$nextTick(function () {
      vm.message = 'hello id: '+ vm.id
    })
  },
  data () {
    return {
        dataSource: {},
        message: null,
        cal: null
    }
  },
  methods: {
    
    addEvent: function (item) {
        var vm = this
    },
    initCal: function (){
        /*call after mounted*/
        var vm = this
        /*this.cal = $(vm.$el)*/
        var args = {
            lang: 'en',
            id: vm.id,
            ell: $(vm.$el),
            header: {
                left:   'prev,next today',
                center: 'title',
                right:  'month,agendaWeek,agendaDay'
            },
            height: "auto",
            allDaySlot: false,
            slotEventOverlap: false,
            timeFormat: 'HH:mm',
            dayClick (date, event, view) {
                console.log(date, event, view)
                console.log(date.format())
            }
        }
        /*this.cal.fullCalendar(args)*/
        this.$emit('init', args)
    }
  },
  mounted () {
    var vm = this
    vm.initCal()
  }
}
</script>

<style>

</style>
