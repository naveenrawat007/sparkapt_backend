smart_apt_monthly = Plan.find_or_create_by!(name: 'SmartAPT Monthly', amount: 49.99, interval: 'month', stripe_plan_id: 'prod_IsP5jtzPdMTDiR')
smartapt_apt_yearly = Plan.find_or_create_by!(name: 'SmartAPT Yearly', amount: 479.99, interval: 'year', stripe_plan_id: 'prod_IsP9Ho30JAp3OF')
