/obj/item/device/thinktronic_parts/program/general/taskmanager
	name = "General Task Manager"
	usealerts = 1
	var/dept = "General"
	var/spamcheck

	New()
		for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
			server = MS
			break
	use_app() //Put all the HTML here
		var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
		dat = ""
		if(pro)
			dat += "<div class='statusDisplay'><center>Mode: Manager</center></div>"
		else
			dat += "<div class='statusDisplay'><center>Mode: User</center></div>"
		if(network())
			dat += "<h4>Your Request List</h4>"
			dat += "<a href='?src=\ref[src];choice=NewRequest'>New Request</a><br>"
			for(var/obj/item/device/thinktronic_parts/data/task/request/task in hdd)
				if(task.assignedby == "[hdd.owner] ([hdd.ownjob])" && task.request)
					dat += "<div class='statusDisplay'>"
					dat += {"<A href='?src=\ref[src];choice=ClearLocalTask;target=\ref[task]'> <b>X</b> </a> "}
					dat += {"<b><u>[task.taskmsg]</b></u>: "}
					dat += {"[task.taskdetail]"}
					dat += {"<br>Assigned to: [task.dept]"}
					dat += {"<br>Status: [task.status]"}
					dat += "</div>"
			dat += "<h4>[dept] Task List</h4>"
			if(pro)
				dat += " <a href='?src=\ref[src];choice=NewTask'>New Task</a>"
			for(var/obj/item/device/thinktronic_parts/data/task/task in server)
				if(task.dept == dept)
					dat += "<div class='statusDisplay'>"
					if(pro || task.assignedby == "[hdd.owner] ([hdd.ownjob])")
						dat += {"<A href='?src=\ref[src];choice=ClearTask;target=\ref[task]'> <b>X</b> </a><br>"}
					dat += {"<b><u>[task.taskmsg]</b></u> [task.request ? "(Request)" : ""]<br>"}
					dat += {"Detail: [task.taskdetail]<br>"}
					dat += {"Assigned By: [task.assignedby]<br>"}
					dat += {"Assigned To: [task.dept]<br>"}
					dat += {"<a href='byond://?src=\ref[src];choice=EditTask;what=change_setting;task=\ref[task]'>[task.status]</a><br>"}
					dat += "</div>"
		else
			dat = "ERROR: No connection to the server"



	Topic(href, href_list) // This is here
		..()
		var/obj/item/device/thinktronic_parts/core/hdd = loc // variable for interactin with the HDD
		var/obj/item/device/thinktronic/PDA = hdd.loc // variable for interacting with the Device itself
		switch(href_list["choice"])
			if("EditTask")
				if(spamcheck) return
				if(href_list["what"] == "change_setting")
					spamcheck = 1
					var/toWhat = input("What do you want to change it to?", "Input") as anything in list("Pending","Accepted", "Denied", "Completed", "Failed")
					spamcheck = 0
					var/obj/item/device/thinktronic_parts/data/task/T = locate(href_list["task"])
					if(!T)	return
					T.status = toWhat
					for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
						if(T.dept == "General")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","General Task Manager")
						if(T.dept == "Security")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Security Task Manager")
						if(T.dept == "Engineering")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Engineering Task Manager")
						if(T.dept == "Medbay")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Medbay Task Manager")
						if(T.dept == "Research")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Research Task Manager")
						if(T.dept == "Cargo Bay")
							MS.SendAlert("<u><b>[T.taskmsg]</u></b> set to [T.status] by [hdd.owner]","Cargo Bay Task Manager")
						break
					AlertUser(T.taskmsg, hdd.owner, T.status, dept)
					PDA.attack_self(usr)
			if("ClearTask")
				if(spamcheck) return
				var/obj/item/device/thinktronic_parts/data/task/task = locate(href_list["target"])
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(task.dept == "General")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","General Task Manager")
					if(task.dept == "Security")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Security Task Manager")
					if(task.dept == "Engineering")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Engineering Task Manager")
					if(task.dept == "Medbay")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Medbay Task Manager")
					if(task.dept == "Research")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Research Task Manager")
					if(task.dept == "Cargo Bay")
						MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Cargo Bay Task Manager")
					break
				AlertUser(task.taskmsg, hdd.owner, null, dept)
				qdel(task)
				PDA.attack_self(usr)
			if("ClearLocalTask")
				if(spamcheck) return
				var/obj/item/device/thinktronic_parts/data/task/ltask = locate(href_list["target"])
				for(var/obj/item/device/thinktronic_parts/data/task/task in server)
					if(task.dept == ltask.dept && task.assignedby == ltask.assignedby && task.taskmsg == ltask.taskmsg && task.taskdetail == ltask.taskdetail)
						for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
							if(task.dept == "General")
								MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","General Task Manager")
							if(task.dept == "Security")
								MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Security Task Manager")
							if(task.dept == "Engineering")
								MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Engineering Task Manager")
							if(task.dept == "Medbay")
								MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Medbay Task Manager")
							if(task.dept == "Research")
								MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Research Task Manager")
							if(task.dept == "Cargo Bay")
								MS.SendAlert("<u><b>[task.taskmsg]</u></b> deleted by [hdd.owner]","Cargo Bay Task Manager")
							break
						qdel(task)
				qdel(ltask)
				PDA.attack_self(usr)
			if("NewTask")
				if(spamcheck) return
				var/obj/item/device/thinktronic_parts/data/task/newtask = new /obj/item/device/thinktronic_parts/data/task(server)
				var/obj/item/device/thinktronic_parts/data/task/newrequest = new /obj/item/device/thinktronic_parts/data/task/request(hdd)
				spamcheck = 1
				var/t = input(usr, "Please enter task title", name, null) as text
				spamcheck = 0
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				if (!t)
					qdel(newtask)
					return
				newtask.taskmsg = t
				newtask.dept = dept
				spamcheck = 1
				var/detail = input(usr, "Please enter task detail", name, null) as text
				spamcheck = 0
				if (!detail)
					qdel(newtask)
					return
				detail = copytext(sanitize(detail), 1, MAX_MESSAGE_LEN)
				newtask.taskdetail = detail
				newtask.assignedby = "[hdd.owner] ([hdd.ownjob])"
				newrequest.taskmsg = t
				newrequest.assignedby = "[hdd.owner] ([hdd.ownjob])"
				newrequest.taskdetail = detail
				newrequest.dept = dept
				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(newtask.dept == "General")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","General Task Manager")
					if(newtask.dept == "Security")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Security Task Manager")
					if(newtask.dept == "Engineering")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Engineering Task Manager")
					if(newtask.dept == "Medbay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Medbay Task Manager")
					if(newtask.dept == "Research")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Research Task Manager")
					if(newtask.dept == "Cargo Bay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Cargo Bay Task Manager")
					break
				PDA.attack_self(usr)
			if("NewRequest")
				if(spamcheck) return
				var/obj/item/device/thinktronic_parts/data/task/newtask = new /obj/item/device/thinktronic_parts/data/task(server)
				var/obj/item/device/thinktronic_parts/data/task/newrequest = new /obj/item/device/thinktronic_parts/data/task/request(hdd)
				spamcheck = 1
				var/t = input(usr, "Please enter message", name, null) as text
				spamcheck = 0
				if (!t)
					qdel(newtask)
					return
				t = copytext(sanitize(t), 1, MAX_MESSAGE_LEN)
				newtask.taskmsg = t
				spamcheck = 1
				var/detail = input(usr, "Please enter request detail", name, null) as text
				spamcheck = 0
				if (!detail)
					qdel(newtask)
					return
				detail = copytext(sanitize(detail), 1, MAX_MESSAGE_LEN)
				newtask.taskdetail = detail
				spamcheck = 1
				var/selectdept = input("Who would you like to assign it to?", "Input") as anything in list("General","Security", "Engineering", "Medbay", "Research", "Cargo Bay")
				spamcheck = 0
				newtask.dept = selectdept
				newtask.request = 1
				newtask.assignedby = "[hdd.owner] ([hdd.ownjob])"
				newrequest.taskmsg = t
				newrequest.assignedby = "[hdd.owner] ([hdd.ownjob])"
				newrequest.taskdetail = detail
				newrequest.dept = selectdept
				newrequest.request = 1

				for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
					if(selectdept == "General")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","General Task Manager")
					if(selectdept == "Security")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Security Task Manager")
					if(selectdept == "Engineering")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Engineering Task Manager")
					if(newtask.dept == "Medbay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Medbay Task Manager")
					if(newtask.dept == "Research")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Research Task Manager")
					if(newtask.dept == "Cargo Bay")
						MS.SendAlert("<u><b>[newtask.taskmsg]</u></b> created by [hdd.owner]","Cargo Bay Task Manager")
					break
				PDA.attack_self(usr)

	proc/AlertUser(var/taskmsg, var/assignedby, var/status, var/dept)
		for (var/list/obj/machinery/nanonet_server/MS in nanonet_servers)
			for(var/obj/item/device/thinktronic/devices in thinktronic_devices)
				var/obj/item/device/thinktronic_parts/core/D = devices.HDD
				if(!D) continue
				for(var/obj/item/device/thinktronic_parts/data/task/request/req in D)
					if(req.assignedby == "[D.owner] ([D.ownjob])")
						if(req.dept == dept)
							if(!status)
								req.status = "DELETED"
								req.request = 1
							if(status)
								req.status = status
							return
						if(!status)
							MS.SendAlertSolo("Task Manager - <u><b>[taskmsg]</u></b> deleted by [assignedby]",devices.device_ID)
							req.status = "DELETED"
						if(status)
							MS.SendAlertSolo("Task Manager - <u><b>[taskmsg]</u></b> set to [status] by [assignedby]",devices.device_ID)
							req.status = status
						break
			break


/obj/item/device/thinktronic_parts/program/general/taskmanager/sec
	name = "Security Task Manager"
	dept = "Security"
/obj/item/device/thinktronic_parts/program/general/taskmanager/engineering
	name = "Engineering Task Manager"
	dept = "Engineering"
/obj/item/device/thinktronic_parts/program/general/taskmanager/medbay
	name = "Medbay Task Manager"
	dept = "Medbay"
/obj/item/device/thinktronic_parts/program/general/taskmanager/science
	name = "Research Task Manager"
	dept = "Research"
/obj/item/device/thinktronic_parts/program/general/taskmanager/cargo
	name = "Cargo Bay Task Manager"
	dept = "Cargo Bay"

//pro version

/obj/item/device/thinktronic_parts/program/general/taskmanager/sec/pro
	name = "Security Task Manager"
	dept = "Security"
	pro = 1
/obj/item/device/thinktronic_parts/program/general/taskmanager/engineering/pro
	name = "Engineering Task Manager"
	dept = "Engineering"
	pro = 1
/obj/item/device/thinktronic_parts/program/general/taskmanager/medbay/pro
	name = "Medbay Task Manager"
	dept = "Medbay"
	pro = 1
/obj/item/device/thinktronic_parts/program/general/taskmanager/science/pro
	name = "Research Task Manager"
	dept = "Research"
	pro = 1
/obj/item/device/thinktronic_parts/program/general/taskmanager/cargo/pro
	name = "Cargo Bay Task Manager"
	dept = "Cargo Bay"
	pro = 1
/obj/item/device/thinktronic_parts/program/general/taskmanager/pro
	name = "General Task Manager"
	dept = "General"
	pro = 1
