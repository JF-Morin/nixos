import { Astal, Gtk, Gdk } from "ags/gtk4"

export default function Music() {
    return (
    <box class="bar-widget" orientation={Gtk.Orientation.HORIZONTAL}>
            <label name="Music-Icon" label="󰓇"/>
            <label name="Music-Title" label="My Music"/>
    </box>
    )
}
