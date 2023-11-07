//
//  HomeView.swift
//  ProgettoSoftwareTesting
//
//  Created by Marco Tammaro on 01/11/23.
//

import SwiftUI

struct TaskView: View {
    
    @StateObject var vm = TaskViewModel()
    
    var body: some View {
        VStack {
            
            if vm.tasks.count == 0 {
                Text("No task found")
                    .accessibilityLabel("NoTaskLabel")
                    .padding()
            }
            
            ZStack(alignment: .bottom) {
                
                List {
                    ForEach(Array(vm.tasks.enumerated()), id: \.offset) { index, task in
                        HStack {
                            Text(task.name)
                                .accessibilityLabel(vm.accessibilityLabelFor(task: task))
                                .fontWeight(.semibold)
                                .strikethrough(task.completed)
                                .opacity(task.completed ? 0.5 : 1)
                            
                        }.onTapGesture {
                            vm.toggleTask(index: index)
                        }
                    }
                    .onDelete(perform: { indexSet in
                        vm.deleteTask(indexSet: indexSet)
                    })
                }
                .background(.white)
                .accessibilityLabel("TaskList")
                
                Button {
                    self.vm.showNewTaskAlert()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 75, height: 75)
                            .shadow(color: .gray.opacity(0.5), radius: 10, x: 7, y: 7)
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .semibold))
                    }
                    
                }.accessibilityLabel("CreateTaskButton")
            }
            
        }
        .navigationTitle("Tasks")
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.deleteAllTask()
                } label: {
                    Image(systemName: "trash")
                }.accessibilityLabel("DeleteAllTaskButton")
            }
        })
        .alert("New Task", isPresented: $vm.newTaskAlertPresented, actions: {
            
            TextField("Name", text: $vm.newTaskName)
            .accessibilityLabel("CreateTaskAlertNameField")
            
            Button("OK", role: .cancel, action: {
                vm.createNewTask()
            }).accessibilityLabel("CreateTaskAlertConfirmButton")
            
        }, message: {
            Text("Please enter the name for the new task")
                .accessibilityLabel("CreateTaskAlertMessage")
        })
    }
}

