		<cfquery name="volume_bid">
			select pa.supplierID, 
			sum(cast(amount as numeric(12,3)) ) as bidAmount 
			from pbt_project_master o 
			left outer join pbt_project_stage ps on ps.bidid = o.bidid
			left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
			inner join
			( 
			select pc.bidID as bidID, amount as bidamount
			from pbt_project_master_cats pc
			left outer join pbt_project_master a on a.bidid = pc.bidid
			left outer join pbt_project_stage ps on ps.bidid = pc.bidid
			left outer join pbt_award_contractors pa on pa.stageID = ps.stageID
			left outer join pbt_project_locations AS pd ON pd.bidID = a.bidID AND pd.active = 1 AND pd.primary_location = 1
			where pa.supplierID = 813
				and a.verifiedpaint = 1 
				and (a.status IN (3, 5))
				and ps.bidtypeID in (5,6)
				and pd.stateID in (2)
			group by pc.bidid,amount
			) d 
			on o.bidID = d.bidID 
			and pa.supplierid = 813
			group by pa.supplierid
		</cfquery>
	