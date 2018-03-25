<template>
    <p class="event-item" :class="cssClasses"
        v-bind:style="eventStyle"
        @click="$emit('click', event, $event)"
        @mouseenter="$emit('mouseenter', event, $event)" 
        @mouseleave="$emit('mouseleave', event, $event)">
        <slot :event="event" v-if="showTitle">
        </slot>
    </p>
</template>

<script>
    import moment from 'moment'
    const COMPONENT_NAME = 'jx-mobilink-calendar-event-card'
    export default {
        name: COMPONENT_NAME,
        props: ['event', 'date', 'firstDay'],
        computed: {
            eventStyle () {
                let eventStyle = {
                    backgroundColor: 'red',
                    color : '#000000'
                }
                var mm = moment()

                if (this.event.activityType == 'EVENT') {
                    eventStyle.backgroundColor = '#c7e6fd'
                } else if (this.event.activityType == 'TASK') {
                    eventStyle.backgroundColor = '#a7a7a7'
                } else {
                    eventStyle.backgroundColor = '#73f184'
                }
                return eventStyle
            },
            cssClasses () {
                let cssClasses = this.event.cssClass;

                if (!Array.isArray(cssClasses)) {
                    cssClasses = [cssClasses];
                } else {
                    cssClasses = Array.from(cssClasses);
                }

                if (this.start.isSame(this.date, 'day')) {
                    cssClasses.push('is-start');
                }

                if (this.end.isSame(this.date, 'day')) {
                    cssClasses.push('is-end');
                }

                if (! this.event.isShow) {
                    cssClasses.push('is-opacity');
                }

                return cssClasses.join(' ');
            },
            showTitle() {
                return (this.date.day() == this.firstDay || this.start.isSame(this.date, 'day') || ( this.event.isShow && this.event.settedIndex > 0 && this.event.settedAgain != true) );
            },
            start () {
                return moment(this.event.startDate.substring(0, 10))
            },
            end () {
                return moment(this.event.endDate.substring(0, 10))
            }
        }
    }
</script>