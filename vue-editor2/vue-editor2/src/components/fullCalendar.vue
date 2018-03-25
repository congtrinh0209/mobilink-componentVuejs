<template>
  <div style="width: 100%;">
    <div class="comp-full-calendar">
      
      <!-- body display date day and events -->
      <div class="full-calendar-body">
        <div class="weeks">
          <strong class="week" v-for="dayIndex in 7" v-bind:key="dayIndex">
            {{ (dayIndex - 1) | localeWeekDay(firstDay, locale) }}
          </strong>
        </div>
        <div class="dates" ref="dates">
          <div class="dates-bg">
            <div class="week-row" v-for="(week, index) in currentDates" v-bind:key="index">
              <div class="day-cell" v-for="(day, index) in week" v-bind:key="index"
                  :class="{'today' : day.isToday,
                'not-cur-month' : !day.isCurMonth}">
                <p class="day-number">{{ day.monthDay }}</p>
              </div>
            </div>
          </div>

          <!-- absolute so we can make dynamic td -->
          <div class="dates-events">
            <div class="events-week" v-for="(week, index) in currentDates" v-bind:key="index">
              <div class="events-day" v-for="(day, index) in week" 
                v-bind:key="index" track-by="$index"
                  :class="{'today' : day.isToday,
                'not-cur-month' : !day.isCurMonth}" @click.stop="dayClick(day.date, $event)">
                <p class="day-number">{{day.monthDay}}</p>
                <div class="event-box">

                  <jx-mobilink-calendar-event-card v-for="(event, index) in day.events" 
                    :date="day.date" :firstDay="firstDay" :event="event"
                    v-show="index < eventLimit" 
                    @click="eventClick" @mouseenter="eventMouseenter"
                    @mouseleave="eventMouseleave" v-bind:key="index">
                      <template scope="p">
                        <slot name="fc-event-card" :event="p.event"></slot>
                      </template>
                  </jx-mobilink-calendar-event-card>
                  
                  <p v-if="day.events.length > eventLimit"
                    class="more-link" @click.stop="selectThisDay(day, $event)">
                    + {{day.events.length - eventLimit}} Xem thêm
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- full events when click show more -->
          <v-dialog v-model="showMore" persistent max-width="900" mt-25 transition="fade-transition">
            <v-card style="min-height: 500px;">
                <v-card-title class="px-0 py-0" style="background-color: rgb(214, 233, 247);min-height: 43px;position: fixed;max-width: 900px;width: 100%;z-index: 9999;">
                    <span class="pl-3">Danh sách sự kiện {{ moreTitle(selectDay.date) }}</span>
                    <v-spacer></v-spacer>
                    
                    <div class="menu" style="display: inline-block;">
                        <div class="menu__activator">
                            <v-btn icon slot="activator" @click.native="showMore = false">
                                <v-icon>close</v-icon>
                            </v-btn>
                        </div>
                    </div>

                </v-card-title>
                <v-card-text style="padding: 0;padding-top: 50px;">
                  <ul class="ul-with-border ul-with-right-icon ul-with-left-icon">
                    <li v-for="(item, index) in selectDay.events" :key="index"
                      v-show="item.isShow">
                      <div class="layout wrap">
                        <div class="flex xs12 sm12">
                          <div class="detail-event-body-">
                            <v-card>
                              <v-card-text>
                                <div>
                                  {{item.cellIndex}}. <a href="javascript:;"  @click="eventClick(item, $event)">{{ item.subject }}</a> | {{ openingStates[item.openingState].text}}
                                </div>
                                <div>
                                  <v-icon>schedule</v-icon>
                                    <span v-show="item.startDate">{{getMoment(item.startDate).format('HH:mm DD/MM/YYYY')}}</span>
                                    <span v-show="item.endDate">
                                      {{' - ' + getMoment(item.endDate).format('HH:mm DD/MM/YYYY')}}
                                    </span>
                                </div>
                                <div>
                                  <v-icon>person</v-icon> Host: {{ item.hosting }} - Manager: {{ item.managerName }}
                                </div>
                                <div>
                                  <v-icon>place</v-icon> {{ item.location }}
                                </div>
                              </v-card-text>
                            </v-card>
                          </div>
                        </div>
                      </div>
                    </li>
                  </ul>
                </v-card-text>
                <v-card-actions>
                  <v-btn color="primary" flat @click.native="showMore = false">
                    <span v-lang.quay_lai></span>
                  </v-btn>
                </v-card-actions>
            </v-card>
          </v-dialog>

          <!-- event detail when hover event -->
          <div class="detail-event" ref="eventHover" v-show="showDetail"
              v-bind:class="detailPos.arrow"
              :style="{left: detailPos.left + 'px', top: detailPos.top + 'px'}">
            <div class="detail-event-body-" v-if="selectEvent.activityId > 0">

              <v-card>
								<v-card-text>
                  <div>
                    {{selectEvent.cellIndex}}. {{ selectEvent.subject }} | {{ openingStates[selectEvent.openingState].text}} 
                  </div>
                  <div>
                    <v-icon>schedule</v-icon>
                    <span v-show="selectEvent.startDate">
                      {{getMoment(selectEvent.startDate).format('HH:mm DD/MM/YYYY')}}
                    </span>
                    <span v-show="selectEvent.endDate">
                      {{' - ' + getMoment(selectEvent.endDate).format('HH:mm DD/MM/YYYY')}}
                    </span>
                  </div>
                  <div>
                    <v-icon>person</v-icon> Host: {{ selectEvent.hosting }} - Manager: {{ selectEvent.managerName }}
                  </div>
                  <div>
                    <v-icon>place</v-icon> {{ selectEvent.location }}
                  </div>
								</v-card-text>
							</v-card>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
</template>
<script type="text/babel">
  /** import langSets from './dataMap/langSets' */
  import dateFunc from '../common/dateFunc'
  import moment from 'moment';
  import EventCard from './eventCard.vue';
  const COMPONENT_NAME = 'jx-mobilink-full-calendar'
  export default {
    name: COMPONENT_NAME,
    props : {
      events : { /** events will be displayed on calendar */
        type : Array,
        default : []
      },
      locale : {
        type : String,
        default : 'en'
      },
      firstDay : {
        type : Number | String,
        validator (val) {
          let res = parseInt(val);
          return res >= 0 && res <= 6
        },
        default : 0
      }
    },
    components : {
      EventCard
    },
    mounted () {
      var vm = this
      this.emitChangeMonth(this.currentMonth)
      vm.openingStates = [{
          openingState: 1,
          text: vm.translate('chua_bat_dau')
          },
          {
              openingState: 2,
              text: vm.translate('dang_thuc_hien')
          },
          {
              openingState: 3,
              text: vm.translate('da_ket_thuc')
          },
          {
              openingState: 4,
              text: vm.translate('da_huy')
          }
        ]
    },
    data () {
      let vm = this
      moment.locale(vm.locale)
      return {
        currentMonth : moment().startOf('month'),
        isLismit : true,
        eventLimit : 3,
        showMore : false,
        showDetail: false,
        selectDay : {},
        selectEvent : {},
        detailPos : {
          arrow: 'center',
          top: 0,
          left : 0
        },
        openingStates: []
      }
    },
    created () {
      
    },
    computed: {
      currentDates () {
        return this.getCalendar()
      }
    },
    methods : {
      getMoment (date) {
        return moment(date)
      },
      emitChangeMonth (firstDayOfMonth) {
        this.currentMonth = firstDayOfMonth;

        let start = dateFunc.getMonthViewStartDate(firstDayOfMonth, this.firstDay);
        let end = dateFunc.getMonthViewEndDate(firstDayOfMonth, this.firstDay);
        this.$emit('changemonth', start, end, firstDayOfMonth)
      },
      goPrev () {
        var newMonth = moment(this.currentMonth).subtract(1, 'months').startOf('month');
        this.emitChangeMonth(newMonth);
      },
      goNext () {
        var newMonth = moment(this.currentMonth).add(1, 'months').startOf('month');
        this.emitChangeMonth(newMonth);
      },
      moreTitle (date) {
        if (!date) return '';
        return moment(date).format('ll');
      },
      getCalendar () {
        /** calculate 2d-array of each month */
        let monthViewStartDate = dateFunc.getMonthViewStartDate(this.currentMonth, this.firstDay);
        let calendar = [];
        for(let perWeek = 0 ; perWeek < 6 ; perWeek++) {
          let week = []
          for(let perDay = 0 ; perDay < 7 ; perDay++) {
            week.push({
              monthDay : monthViewStartDate.date(),
              isToday : monthViewStartDate.isSame(moment(), 'day'),
              isCurMonth : monthViewStartDate.isSame(this.currentMonth, 'month'),
              weekDay : perDay,
              date : moment(monthViewStartDate),
              events : this.slotEvents(monthViewStartDate)
            })
            monthViewStartDate.add(1, 'day')
          }
          calendar.push(week)
        }

        return calendar
      },
      slotEvents (date) {
        /** find all events start from this date */
        let cellIndexArr = []
        let thisDayEvents = this.events.filter(day => {
          let st = moment(day.startDate.substring(0, 10))
          let ed = moment(day.endDate ? day.endDate.substring(0, 10) : st)

          return date.isBetween(st, ed, null, '[]')
        })
        let eventLim = this.eventLimit
        /** sort by duration */
        thisDayEvents.sort((a,b)=>{
          if(!a.cellIndex) return 1;
          if (!b.cellIndex) return -1;
          return a.cellIndex - b.cellIndex
        })

        /** mark cellIndex and place holder */
        for (let i = 0;i < thisDayEvents.length;i++) {
          thisDayEvents[i].cellIndex = thisDayEvents[i].cellIndex || (i + 1)
          thisDayEvents[i].cellIndex = thisDayEvents[i].settedIndex || thisDayEvents[i].cellIndex
          
          thisDayEvents[i].isShow = true
          if (thisDayEvents[i].cellIndex == i+1 || i>= eventLim-1) {
            continue
          }
          thisDayEvents.splice(i,0,{
            subject : 'holder',
            cellIndex : i+1,
            startDate : date.format(),
            endDate : date.format(),
            isShow : false
          })
        }

        for (let i = 0;i < thisDayEvents.length;i++) {
          if(thisDayEvents.length > eventLim && thisDayEvents[eventLim].settedIndex > 0) {
            thisDayEvents[eventLim].settedAgain = true
          }
          if (thisDayEvents[i].settedIndex > 0) {
            thisDayEvents[i].settedAgain = true
          }
          if ((thisDayEvents.length > eventLim) &&
            thisDayEvents[eventLim].isShow &&
            !thisDayEvents[i].isShow) {
                
                this.events.filter(day => {
                  return day.activityId == thisDayEvents[eventLim]['activityId']
                })[0].settedIndex = thisDayEvents[i].cellIndex
                for(let key in thisDayEvents[eventLim]) {
                  if (key === 'cellIndex') {
                    thisDayEvents[i]['settedIndex'] = thisDayEvents[i][key]
                    continue
                  }
                  thisDayEvents[i][key] = thisDayEvents[eventLim][key]
                }

                thisDayEvents.splice(eventLim, 1)
          }
        }
        return thisDayEvents
      },
      selectThisDay (day, jsEvent) {
        this.selectDay = day
        this.showMore = true
        let events = day.events.filter(item =>{
          return item.isShow == true
        })
        this.$emit('moreclick', day.date, events, jsEvent)
      },
      computePos (target) {
        let eventRect = target.getBoundingClientRect()
        let pageRect = this.$refs.dates.getBoundingClientRect()
        let eventHoverRect = this.$refs.eventHover.getBoundingClientRect()
        let posLeft = eventRect.left + eventRect.width/2 - pageRect.left - eventHoverRect.width/2
        let posRight = eventRect.left + eventRect.width/2 + eventHoverRect.width/2
        let arrow = 'center'
        if (posLeft<0) {
          posLeft = 0
          arrow = 'left'
        } else if (pageRect.right < posRight) {
          arrow = 'right'
          posLeft = pageRect.right-eventHoverRect.width-pageRect.left
        }

        return {
          arrow : arrow,
          left : posLeft,
          top  : eventRect.top + eventRect.height - pageRect.top
        }
      },
      dayClick(day, jsEvent) {
        this.$emit('dayclick', day, jsEvent)
      },
      eventClick(event, jsEvent) {
        if (!event.isShow) return;
        this.showMore = false
        this.selectEvent = event
        jsEvent.stopPropagation()
        let pos = this.computePos(jsEvent.target)
        this.detailPos = pos
        this.$emit('eventclick', event, jsEvent, pos)
      },
      eventMouseenter(event, jsEvent) {
        jsEvent.stopPropagation()
        if (!event.isShow) return;
        this.selectEvent = event
        let pos = this.computePos(jsEvent.target)
        this.detailPos = pos
        this.showDetail = true
        this.$emit('eventMouseenter', event, jsEvent, pos)
      },
      eventMouseleave(event, jsEvent) {
        this.selectEvent = event
        this.showDetail = false
        this.$emit('eventMouseleave', event, jsEvent.target)
      }
    },
    filters: {
      localeWeekDay (weekday, firstDay, locale) {
        firstDay = parseInt(firstDay);
        const localMoment = moment().locale(locale);
        return localMoment.localeData().weekdaysShort()[(weekday + firstDay) % 7];
      }
    }
  }
  
</script>
<style >
.comp-full-calendar {
  padding: 0px;
  background: #fff;
  /** max-width: 1024px;*/
  margin: 0 auto;
}
.comp-full-calendar ul, .comp-full-calendar p {
  margin: 0;
  padding: 0;
}
.full-calendar-body {
  /** margin-top: 20px;*/
}
.full-calendar-body .weeks {
  display: flex;
  border-top: 1px solid #e0e0e0;
  border-bottom: 1px solid #e0e0e0;
  border-left: 1px solid #e0e0e0;
}
.full-calendar-body .weeks .week {
  flex: 1;
  text-align: center;
  border-right: 1px solid #e0e0e0;
}
.full-calendar-body .dates {
  position: relative;
}
.full-calendar-body .dates .week-row {
  border-left: 1px solid #e0e0e0;
  display: flex;
}
.full-calendar-body .dates .week-row .day-cell {
  flex: 1;
  min-height: 132px;
  padding: 4px;
  border-right: 1px solid #e0e0e0;
  border-bottom: 1px solid #e0e0e0;
}
.full-calendar-body .dates .week-row .day-cell .day-number {
  text-align: right;
}
.full-calendar-body .dates .week-row .day-cell.today {
  background-color: #fcf8e3;
}
.full-calendar-body .dates .week-row .day-cell.not-cur-month .day-number {
  color: rgba(0, 0, 0, .24);
}
.full-calendar-body .dates .dates-events {
  position: absolute;
  top: 0;
  left: 0;
  z-index: 1;
  width: 100%;
}
.full-calendar-body .dates .dates-events .events-week {
  display: flex;
}
.full-calendar-body .dates .dates-events .events-week .events-day {
  cursor: pointer;
  flex: 1;
  min-height: 132px;
  overflow: hidden;
  text-overflow: ellipsis;
}
.full-calendar-body .dates .dates-events .events-week .events-day .day-number {
  text-align: right;
  padding: 4px 5px 4px 4px;
  opacity: 0;
}
.full-calendar-body .dates .dates-events .events-week .events-day.not-cur-month .day-number {
  color: rgba(0, 0, 0, .24);
}
.full-calendar-body .dates .dates-events .events-week .events-day .event-box .event-item {
  cursor: pointer;
  font-size: 12px;
  margin-bottom: 2px;
  padding: 0 0 0 4px;
  height: 25px;
  line-height: 18px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  line-height: 25px;
}

.full-calendar-body .dates .dates-events .events-week .events-day .event-box .event-item.is-end {
  margin-right: 4px;
}
.full-calendar-body .dates .dates-events .events-week .events-day .event-box .event-item.is-start {
  margin-left: 4px;
}
.full-calendar-body .dates .dates-events .events-week .events-day .event-box .event-item.is-opacity {
  opacity: 0;
}
.full-calendar-body .dates .dates-events .events-week .events-day .event-box .more-link {
  cursor: pointer;
  padding-left: 8px;
  padding-right: 2px;
  color: rgba(0, 0, 0, .38);
  font-size: 14px;
}
.full-calendar-body .dates .detail-event {
  position: absolute;
  z-index: 2;
  border: 1px solid #eee;
  box-shadow: 0 2px 6px rgba(0, 0, 0, .15);
  margin-top: 15px;
  width: 300px;
}

.full-calendar-body .dates .detail-event .detail-event-body- {
  overflow: hidden;
}
.full-calendar-body .dates .detail-event .detail-event-body- .detail-event-detail-event-detail-event-body-list {
  padding: 5px;
  overflow: auto;
  background-color: #fff;
}
.full-calendar-body .dates .detail-event .detail-event-body- .detail-event-detail-event-detail-event-body-list .body-item {
  cursor: pointer;
  font-size: 12px;
  background-color: #c7e6fd;
  margin-bottom: 2px;
  color: rgba(0, 0, 0, .87);
  padding: 0 0 0 4px;
  height: 18px;
  line-height: 18px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  min-height: 112px;
}
.full-calendar-body .dates .detail-event:after {
  content: "";
  position: absolute;
  top: -11px;
  left: 50%;
  width: 20px;
  height: 20px;
  -webkit-transform: rotate(45deg);
  transform: rotate(45deg);
  border: 1px solid #ddd;
  border-width: 1px 0 0 1px;
  margin-left: -10px;
  background-color: white;
}
.full-calendar-body .dates .detail-event.left:after {
  left: 25%;
  -webkit-transform: rotate(45deg) translateX(0);
  transform: rotate(45deg) translateX(0);
}
.full-calendar-body .dates .detail-event.right:after {
  left: 75%;
  -webkit-transform: rotate(45deg) translateX(0);
  transform: rotate(45deg) translateX(0);
}

</style>