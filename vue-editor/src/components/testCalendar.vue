<template>
  <div>
  	<p>
  		Here is the demo of vue-fullcalendar, no jquery fullcalendar.js required!
  	</p>
    <jx-mobilink-full-calendar class="test-fc" :events="fcEvents" 
      first-day='1' locale="vi"
      @changeMonth="changeMonth"
      @eventClick="eventClick"
      @dayClick="dayClick"
      @moreClick="moreClick">
        <template slot="fc-event-card" scope="p">
            <p><i class="fa">sadfsd</i> {{ p.event.title }} test</p>
        </template>
        <template slot="fc-header-left">LEFT</template>
        <template slot="fc-header-right">
          <div style="text-align: right;">RIGHT</div>
        </template>
    </jx-mobilink-full-calendar>
  </div>
</template>
<script>
import FullCalendar from './fullCalendar.vue';
let demoEvents = [
    {
      title    : 'Sunny 725-727',
      start    : '2018-02-25',
      end      : '2018-02-27',
      cssClass : 'family'
    },
    {
      title : 'Lunfel 726-727',
      start : '2018-02-26',
      end : '2018-02-27',
      cssClass : ['home', 'work']
    },
    {
      title : 'Lunfel 2/27-2/28',
      start : '2018-02-27',
      end : '2018-02-28'
    },
    {
        title : 'Lunfel 2/27-2/28',
        start : '2018-02-27',
        end : '2018-02-28'
    },
    {
        title : 'Lunfel 2/27-2/28',
        start : '2018-02-27',
        end : '2018-02-28'
    },
    {
        title : 'Lunfel 2/26-3/05',
        start : '2018-02-26',
        end : '2018-03-05'
    },
    {
        title : 'Lunfel 1/27-1/28',
        start : '2018-01-27',
        end : '2018-01-28'
    },
    {
        title : 'Lunfel 1/27-2/2',
        start : '2018-01-27',
        end : '2018-02-02'
    },
    {
        title : 'Lunfel 3/27-3/28',
        start : '2018-03-27',
        end : '2018-03-28'
    },
  ];

const COMPONENT_NAME = 'jx-mobilink-test-calendar'
  export default {
    name: COMPONENT_NAME,
	data () {
		return {
            name:'Sunny!',
            fcEvents : demoEvents
        }
	},
  methods : {
    'changeMonth' (start, end, current) {
      console.log('changeMonth', start.format(), end.format(), current.format())
    },
    'eventClick' (event, jsEvent, pos) {
       console.log('eventClick', event, jsEvent, pos)
    },
    'dayClick' (day, jsEvent) {
      console.log('dayClick', day, jsEvent)
    },
    'moreClick' (day, events, jsEvent) {
      console.log('moreCLick', day, events, jsEvent)
    }
  },
  components : {
    FullCalendar
  }
}
</script>
<style>
.app {
  color: green;
}
</style>