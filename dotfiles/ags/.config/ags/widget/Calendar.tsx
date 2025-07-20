import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"

export default function Calendar(){
    const time = createPoll("", 1000, "date '+%F %T'")

    return (
        <box class="bar-widget">
            <label class="icon" label="󰃰"/>
            <label label={time} />
        </box>
    )
}

