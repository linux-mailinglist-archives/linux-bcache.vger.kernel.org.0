Return-Path: <linux-bcache+bounces-1239-lists+linux-bcache=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEFBBC4E1D0
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Nov 2025 14:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3AE73A9DDF
	for <lists+linux-bcache@lfdr.de>; Tue, 11 Nov 2025 13:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D18D76025;
	Tue, 11 Nov 2025 13:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="JGPrZC16"
X-Original-To: linux-bcache@vger.kernel.org
Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B565A2BE03B
	for <linux-bcache@vger.kernel.org>; Tue, 11 Nov 2025 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762867846; cv=none; b=V9PWzD8hVCW0CtDTunMSPYOwk0sCK3mCZrNGvLcw3Lx1OcanIdvnSDKfM80rCEtHJQugd8mzTUDBDfv7Lnxe4v/vcTnTFOefGnpB6lPu3XYe5nNg8umE7uGEEigOrEBXd8sWntZ/nBQVoP0FPsbWH+tJX+JsIBjzfLR41UzABac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762867846; c=relaxed/simple;
	bh=v0lSqiq2sWo3T0BJrMwy11NLOv/j2DiOsf7GTvaYqaA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fcCpK5ocQ2bT/ZZBGkDDorBJUCnMoS41J2YOmSg5xQ3j+2h0jb3fr7atyB5g+FP+4iRhY2szdk32xD29arfdNPReyj7fXnme7WViAJXugFR13N7CyShbE0NzFCXsd40z33AJTSwSHVdrTJKLO4WrWumo5MX0ESet9iuNc9w6F+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=JGPrZC16; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id InEQvbM5qv724IoQmvRwNd; Tue, 11 Nov 2025 13:29:08 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id IoQlv4pL0niktIoQmvRccK; Tue, 11 Nov 2025 13:29:08 +0000
X-Authority-Analysis: v=2.4 cv=FOIbx/os c=1 sm=1 tr=0 ts=69133a24
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=F0GicbU7tRTSLTLZ85HXVw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=xLSupZCTIYbk7TSy1gAA:9 a=QEXdDO2ut3YA:10 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2jv3T9IIY8maauDuJooEDt1SGO1tZAtuNsKX38mdNHc=; b=JGPrZC1615NoUm7gtzKIIF1KUm
	rrGWTn+p4TOVknZ4HeAh3LLf6Cew9qfVW+wks3oWWnCbLCQZn554+g1E0msGJFuDgoqFV465QuFx6
	O/RnzAiJlRPxwATGcvAi/FiGBWF66KtKmAZM1APPh8ESaURWjP7krDZoQiGDbFk3cMa2fgb6+Kg4U
	MDsdHPYQrRpXznDesHfjH64y8eRZHTYAbBDb5W7soSFXTSaWt101UEEYE6EHXnpAXhwLD3gnV3BKw
	wLD/gz0AakCkFD42AXlErqQaR92Fb28AcBLtcbRgOS3w8BPSPzTuexIM4hvCKONkpA7+oBD9X8zM7
	Wbg0uk+A==;
Received: from m106072098064.v4.enabler.ne.jp ([106.72.98.64]:32830 helo=[10.221.86.44])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1vIoQl-00000000cju-1tgA;
	Tue, 11 Nov 2025 07:29:07 -0600
Message-ID: <a956504a-55af-4c2c-95a0-15663435624a@embeddedor.com>
Date: Tue, 11 Nov 2025 22:28:57 +0900
Precedence: bulk
X-Mailing-List: linux-bcache@vger.kernel.org
List-Id: <linux-bcache.vger.kernel.org>
List-Subscribe: <mailto:linux-bcache+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcache+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][next] bcache: Avoid -Wflex-array-member-not-at-end
 warning
To: Coly Li <colyli@fnnas.com>, "Gustavo A. R. Silva"
 <gustavoars@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <aRHFchrO3BmVMH5c@kspp>
 <7g2dkwi2nzxe2luykodsknobzr5bkl23d5mbahkyo7adhg55oy@6uisoc7jzgy6>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <7g2dkwi2nzxe2luykodsknobzr5bkl23d5mbahkyo7adhg55oy@6uisoc7jzgy6>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 106.72.98.64
X-Source-L: No
X-Exim-ID: 1vIoQl-00000000cju-1tgA
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: m106072098064.v4.enabler.ne.jp ([10.221.86.44]) [106.72.98.64]:32830
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAs7gmjOv5Rcf0Rw8RqgnGsYGBztIk/BcXg5LTvawRJNvl2QVr9kJAJhq3IKc91//bjYYlP6eBln91UQslpkP73949KUqqTRbZmYNfMMEcD8g4S1fMJX
 1/UAU5XfhlIc/6qzGG9T6enYMnR+Hl7RF357UTSdhjZiW+yZvsvYQZksM94YN61tYNUQ18YCxeIc1qsxVTsoMfxQIND/YlyKR2hMFTQDuCa1CvTKwwQoolhp



On 11/11/25 22:17, Coly Li wrote:
> On Mon, Nov 10, 2025 at 07:58:58PM +0800, Gustavo A. R. Silva wrote:
>> -Wflex-array-member-not-at-end was introduced in GCC-14, and we are
>> getting ready to enable it, globally.
>>
>> Use the new TRAILING_OVERLAP() helper to fix the following warning:
>>
>> drivers/md/bcache/bset.h:330:27: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
>>
>> This helper creates a union between a flexible-array member (FAM) and a
>> set of MEMBERS that would otherwise follow it.
>>
>> This overlays the trailing MEMBER struct btree_iter_set stack_data[MAX_BSETS];
>> onto the FAM struct btree_iter::data[], while keeping the FAM and the start
>> of MEMBER aligned.
>>
>> The static_assert() ensures this alignment remains, and it's
>> intentionally placed inmediately after the corresponding structures --no
>> blank line in between.
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>   drivers/md/bcache/bset.h | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
>> index 011f6062c4c0..6ee2c6a506a2 100644
>> --- a/drivers/md/bcache/bset.h
>> +++ b/drivers/md/bcache/bset.h
>> @@ -327,9 +327,13 @@ struct btree_iter {
>>   /* Fixed-size btree_iter that can be allocated on the stack */
>>   
>>   struct btree_iter_stack {
>> -	struct btree_iter iter;
>> -	struct btree_iter_set stack_data[MAX_BSETS];
>> +	/* Must be last as it ends in a flexible-array member. */
>> +	TRAILING_OVERLAP(struct btree_iter, iter, data,
>> +		struct btree_iter_set stack_data[MAX_BSETS];
>> +	);
>>   };
>> +static_assert(offsetof(struct btree_iter_stack, iter.data) ==
>> +	      offsetof(struct btree_iter_stack, stack_data));
>>
> 
> I have to say this is ugly. Not the patch, but the gcc 14 warning option
> of such coding style. Look at TRAILING_OVERLAP() usage here, this is not
> C, this is something to fix a gcc bug which cannot handle FAM properly.

This is not a GCC bug.

> 
> Gustavo, this complain is not to you, just I feel a bit sad how GCC makes
> the code comes to such an ugly way, and it makes things much complicated.
> For anyone doesn't have deep understanding of TRAILING_OVERLAP(), I
> highly suspect whether he or she can understand what happens here.
> 
> Andrew and Gustavo, is this a mandatary to fix FAM in such way? If yes
> I take the patch and keep my own opinion. If not, I'd like to see gcc
> fixes its bug, for the this code I don't see the author does things
> wrong.

This is a false positive that needs to be addressed in some way in order to
enable -Wflex-array-member-not-at-end in mainline.

Here you can take a look at the patches I (and others) have submitted to
modify similar code over the last year:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/log/?qt=grep&q=-Wflex-array-member-not-at-end

Thanks
-Gustavo



