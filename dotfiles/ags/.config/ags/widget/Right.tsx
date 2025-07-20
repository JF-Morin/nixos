import { Astal, Gtk, Gdk } from "ags/gtk4"
import Logout from "./Logout"
import Calendar from "./Calendar"

export default function Right() {
    return (
        <box class="Right" orientation={Gtk.Orientation.HORIZONTAL}>
            <Calendar />
            <Logout />
        </box>
    )
}
