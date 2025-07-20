import { Astal, Gtk, Gdk } from "ags/gtk4"
import Music from "./Music"
import Nixos from "./Nixos"

export default function Left() {
    return (
        <box class="Left" orientation={Gtk.Orientation.HORIZONTAL}>
            <Nixos />
            <Music />
        </box>
    )
}
