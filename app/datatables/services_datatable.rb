class ServicesDatatable
  include ApplicationHelper  
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: Service.count,
      iTotalDisplayRecords: fetch_services(true),
      aaData: data
    }
  end

  def as_csv
    CSV.generate do |csv| 
      csv << ['#', 'HubID', 'Project Name', 'Client Name', 'Project Value', 'Client Category', 'Status', 'Project Comments', 'PM', 'SM', 'Eng. Type',
              'Service', 'Consultant', 'Start Date', 'Service Price', 'Duration', 'Service Status', 'Service Comments', 'Sold By', 'Year'
      ]
      i = 0
      fetch_services(false, true).each do |service|
        i = i+1
        csv << 
        [ i,
          service.project.hub_id,
          service.project.name,
          service.project.client,
          service.project.budget,
          Project.client_abc[service.project.abc],
          Project.conversion_status[service.project.converted],
          service.project.status_comment,
          service.project.project_manager,
          service.project.sales_manager,
          Project.engagement_types[service.project.engagement_type],
          service.service_type.name,
          service.consultant.name,
          service.start_date.strftime("%b %e, %Y"),
          service.budget,          
          service.duration,
          Service.statuses[service.success_status].to_s.capitalize,
          service.status_comment,
          service.sold_by == 0 ? 'Sales Manager' : service.sales_force.name,
          service.start_date.strftime("%Y"),
        ]
      end
    end
  end

private

  def data 
    services.map do |service|
      project_status_image = ''
      project_status_comment = ''
      service_status_comment = service.status_comment == '' || service.status_comment == nil ? '<i>No comment</i>' : service.status_comment

      if service.project.engagement_type != Project.engagement_types.index(:service_only)
        if service.project.converted == 1
          img = 'won.png'
        elsif service.project.converted == 2
          img = 'lost.png'
        else
          img = 'potential.png'
        end
        project_status_image = image_tag(img, {:width => 30, :class => 'show_comment', :popup_div => "project_status_comment_#{service.id}"})
        project_status_comment = service.project.status_comment == '' || service.project.status_comment == nil ? '<i>No comment</i>' : service.project.status_comment
      end

      project_name = ("<div style='float:left; width: 85&#37;;'><b> %s</b>: %s <br /> <b>Budget:</b> %s</div><div style='float:right'>%s<div class='pop-up' id='project_status_comment_#{service.id}'><b>Client Category:</b> #{Project.client_abc[service.project.abc]}<br /><b>Project Comment</b>: #{project_status_comment}</div></div>" % 
                      [service.project.client, service.project.name, ApplicationHelper.comma_numbers(service.project.budget), project_status_image]).html_safe
      
      service_status_image = image_tag("#{Service.statuses[service.success_status]}.png", {:class => 'show_comment', :popup_div => "service_status_comment_#{service.id}"})

      people = ('<b>Consultant:</b> %s, <b>Sold By:</b> %s<br />
          <b>PM:</b> %s, <b>SM:</b> %s<br />
          ' % [
            service.consultant.name, 
            service.sold_by == 0 ? 'Sales Manager' : service.sales_force.name,
            service.project.project_manager, 
            service.project.sales_manager
            
          ]
      ).html_safe
      deliveries = ('
          <b>Spec:</b> %s<br />
          <b>Proposal:</b> %s' % [service.proposal_sent ? 'SENT' : 'NOT SENT', service.spec_sent ? 'SENT' : 'NOT SENT']
      ).html_safe

      edit_link = link_to(image_tag('edit.png', {:width => 20}), "/service_project_form/#{service.id}", :class => 'fancybox', :form_id => 'project_form', :services_update_url => "/services/#{service.id}", :projects_update_url => "/projects/#{service.project.id}")
      delete_link = link_to(image_tag('delete.png', {:width => 20}), "/services/#{service.id}", :confirm => "Are you sure you want to delete this service?", "_method" => "delete")
      
      link_to_hub = ApplicationHelper.form_hub_link(service.project.hub_id)
      links = "%s&nbsp;%s&nbsp;%s" % [edit_link, delete_link, link_to_hub]
       
      [
        project_name,
        service.service_type.name,
        service.start_date.strftime("%b&nbsp;%e,&nbsp;%Y"),
        service.duration,
        #service.start_date.strftime('%V'),
        "#{mark_paid(ApplicationHelper.comma_numbers(service.budget), service.is_paid)}".html_safe,
        people,
        #deliveries,
        ("#{service_status_image} <div class='pop-up' id='service_status_comment_#{service.id}'><b>Service Comment</b>: #{service_status_comment}</div>").html_safe,
        links
      ]
    end
  end

  def image_tag src, opt = {:width => 30}
    ActionController::Base.helpers.image_tag src, opt
  end

  def services
    @services ||= fetch_services
  end

  def fetch_services total_records = false, fetch_all = false
    services = Service.order("#{sort_column} #{sort_direction}")
    if total_records == false and fetch_all == false
      services = services.page(page).per_page(per_page)
    end
    if params[:consultant].present? and params[:consultant].to_i != 0
      services = services.where("u1.id = :consultant or u2.id = :consultant", consultant: params[:consultant])
    end
    if params[:status].present? and params[:status].to_i != 0
      services = services.where("success_status = :status ", status: params[:status])
    end    
    if params[:sSearch].present?
      if /^([a-zA-Z_]+):([\w\s,\|]+);?.?/.match(params[:sSearch])
        seach_keys = params[:sSearch].split(';')
        seach_keys.each do |search_key|
          continue if search_key == ''
          if /^\s?([a-zA-Z_]+):([\w\s,\|\.]+)$/.match(search_key)
            first_match = Regexp.last_match(1)
            second_match = Regexp.last_match(2)
            continue if search_key == 'all'

            case first_match.downcase
            when 'project_conversion', 'pc'
              key_field = "p.engagement_type = #{Project.engagement_types[:project_delivery]} and p.converted = "             
            when 'sold_by', 'sb'
              key_field = "u2.name like "
            when 'pm'
              key_field = "p.project_manager like "
            when 'sm'
              key_field = "p.sales_manager like "
            when 'client', 'c'
              key_field = "p.client like "
            when 'project', 'p'
              key_field = "p.name like "
            when 'consultant', 'con'
              key_field = "u1.name like "
            when 'service', 's'
              key_field = " s.name like "
              if /([a-zA-Z]+)\|([a-zA-Z]*)$/.match(second_match)
                key_field = "#{key_field} '%#{Regexp.last_match(1)}%' OR s.name like "
                second_match = Regexp.last_match(2)
              end
            when 'status', 'stat'
              key_field = "success_status = "
            when 'date', 'd'
              begin
                date = Date.parse(second_match)
                key_field = "month(start_date) = #{date.month} and year(start_date) = #{date.year}"
                if /^[a-zA-Z]{3}[,?|\s?]+([0-9]{1,2})[\s]*?[,?|\s?]+(20[0-9]{2})$/.match(second_match.to_s)
                  key_field = "#{key_field} and day(start_date) = #{date.day}"
                end
              rescue
                {:error => 'bla'}
              end 
            end

            if first_match != 'date' and first_match != 'd'
              if first_match.downcase == 'status' or first_match.downcase == 'stat'
                search_value = find_index_by_regex(Service.statuses, dehumanize_text(second_match))
              else
                case first_match.downcase
                when 'project_conversion', 'pc'
                  conversion_status = Regexp.last_match(2)
                  if conversion_status == 'potential'
                    conversion_status = 'pending'
                  end
                  search_value = Project.conversion_status[Regexp.last_match(2).to_sym]
                else
                  search_value = "%#{second_match}%"
                end
              end
            else
              if key_field != nil
                key_field = "#{key_field} and "
              end
              search_value = 1
            end

            services = services.where("#{key_field} :search_value", search_value: "#{search_value}")
          end
        end

      else
        dehumanized_search = dehumanize_text(params[:sSearch]) #params[:sSearch].tr!(' ','_').to_s
        dehumanized_search = dehumanized_search.downcase.to_sym
        services = services.where("
                                p.name like :search or 
                                p.client like :search or 
                                p.project_manager like :search or 
                                p.sales_manager like :search or 
                                u1.name like :search or 
                                u2.name like :search or
                                s.name like :search or 
                                s.key_name like :search or
                                success_status = :success_status
                                ", search: "%#{params[:sSearch]}%",  success_status: Service.statuses.index(dehumanized_search))
      end
    end    
    services = services.joins('LEFT JOIN `projects` p ON p.id = services.project_id 
                              LEFT JOIN `users` u1 ON u1.id = services.user_id 
                              LEFT JOIN `users` u2 ON u2.id = services.sold_by
                              LEFT JOIN `service_types` s ON s.id = services.service_type_id
                            ').all
    
    total_records ? services.count : services
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[p.name s.name start_date duration is_paid u1.name success_status]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "asc" ? "asc" : "desc"
  end

  def dehumanize_text str
    str.tr!(' ','_').to_s
    str.downcase
  end

  def mark_paid str, paid
    if paid
      str = "<span style='font-weight:bold; color: green;'>#{str}</span>"
    else
      str = "<span style='color: red;'>#{str}</span>"
    end
    str
  end


  def find_index_by_regex hash, str
    found_key = nil
    hash.each do |k,v|
      if /^#{str}.*/.match(v.to_s)
        found_key = k
      end
    end
    found_key
  end
end