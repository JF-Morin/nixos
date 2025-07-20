import { Astal, Gtk, Gdk } from "ags/gtk4"
import Workspaces from "./Workspaces"

export default function Center() {
    return (
        <box orientation={Gtk.Orientation.HORIZONTAL}>
            <Workspaces />
        </box>
    )
}
