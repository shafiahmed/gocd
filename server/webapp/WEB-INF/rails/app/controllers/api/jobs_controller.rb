##########################GO-LICENSE-START################################
# Copyright 2014 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################GO-LICENSE-END##################################

java_import 'org.springframework.dao.DataRetrievalFailureException'

class Api::JobsController < Api::ApiController
  include ApplicationHelper

  def render_not_found()
    render :text => "Not Found!", :status => 404
  end

  def index
    return render_not_found unless number?(params[:id])
    job_id = Integer(params[:id])
    begin
      @doc = xml_api_service.write(JobXmlViewModel.new(job_instance_service.buildById(job_id)), "#{request.protocol}#{request.host_with_port}/go")
    rescue Exception => e
      logger.error(e)
      return render_not_found
    end
  end

  def scheduled
    scheduled_waiting_jobs = job_instance_service.waitingJobPlans()
    @doc = xml_api_service.write(JobPlanXmlViewModel.new(scheduled_waiting_jobs), "#{request.protocol}#{request.host_with_port}/go")
  end
end
