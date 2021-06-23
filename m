Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDEB3B13A5
	for <lists+linux-bcache@lfdr.de>; Wed, 23 Jun 2021 08:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbhFWGGP (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 23 Jun 2021 02:06:15 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:42594 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhFWGGO (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 23 Jun 2021 02:06:14 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B425B2191C;
        Wed, 23 Jun 2021 06:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/75pFNjbtFEvejhPibGMochJt2tfZuidrpJaHOLw8I=;
        b=hkrnaIK9M0eb3tT42Rk8IVdBbnzWimMqfDtg4OFyOdl/bgWK07BQLKDwoluQCBIOycBeH9
        oN4vENH5WQzT/WRb5HY/s5dRD3wkVLl0iX18K++hZow5k7+YBrut0JyeKlbE7p4sd6oUq1
        XD5noHeM02EoeueSxmVwBtkRaf7bVco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428236;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/75pFNjbtFEvejhPibGMochJt2tfZuidrpJaHOLw8I=;
        b=eS8Q2TZZpquJPtZm9Gi+vghpsPTSMwFA9rjE49404l9qR3B7roTdGVGlYjkUSLCVzc1HVb
        1ULsFqEBuD4IoQAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id B2F2111A97;
        Wed, 23 Jun 2021 06:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1624428236; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/75pFNjbtFEvejhPibGMochJt2tfZuidrpJaHOLw8I=;
        b=hkrnaIK9M0eb3tT42Rk8IVdBbnzWimMqfDtg4OFyOdl/bgWK07BQLKDwoluQCBIOycBeH9
        oN4vENH5WQzT/WRb5HY/s5dRD3wkVLl0iX18K++hZow5k7+YBrut0JyeKlbE7p4sd6oUq1
        XD5noHeM02EoeueSxmVwBtkRaf7bVco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1624428236;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/75pFNjbtFEvejhPibGMochJt2tfZuidrpJaHOLw8I=;
        b=eS8Q2TZZpquJPtZm9Gi+vghpsPTSMwFA9rjE49404l9qR3B7roTdGVGlYjkUSLCVzc1HVb
        1ULsFqEBuD4IoQAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id yxd5IMrO0mCoXAAALh3uQQ
        (envelope-from <colyli@suse.de>); Wed, 23 Jun 2021 06:03:54 +0000
Subject: Re: [PATCH 05/14] bcache: initialization of the buddy
To:     Pavel Goran <via-bcache@pvgoran.name>
Cc:     Hannes Reinecke <hare@suse.de>, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, Jianpeng Ma <jianpeng.ma@intel.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, axboe@kernel.dk,
        Qiaowei Ren <qiaowei.ren@intel.com>
References: <20210615054921.101421-1-colyli@suse.de>
 <20210615054921.101421-6-colyli@suse.de>
 <bfa10634-b144-e180-c66a-5bf839c5ce71@suse.de>
 <e66262c1-7ce1-cd67-b48b-982b6d1ea1d1@suse.de>
 <133698796.20210623124604@pvgoran.name>
From:   Coly Li <colyli@suse.de>
Message-ID: <3e1c9885-1f8f-a501-3e33-66794ed54fce@suse.de>
Date:   Wed, 23 Jun 2021 14:03:52 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <133698796.20210623124604@pvgoran.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/23/21 1:46 PM, Pavel Goran wrote:
> Hello Coly,
>
> Wednesday, June 23, 2021, 12:35:21 PM, you wrote:
>
>> ... (skipped a lot)
>>>> +                            /* recs array can has hole */
>>> can have holes ?
>> It means the valid record is not always continuously stored in recs[]
>> from struct bch_nvm_pgalloc_recs. Because currently only 8 bytes write
>> to a 8 bytes aligned address on NVDIMM is stomic for power failure.
>> ...
> The issue is with the wording of this comment, not with the code or the
> meaning of the comment.
>
> The comment should read "recs array can have hole".

Oh, I see. Thank Pavel for the hint :-) We will update it in next post.

Coly Li
