Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A333191F66
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Mar 2020 03:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgCYCnB (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Mar 2020 22:43:01 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35967 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgCYCnB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Mar 2020 22:43:01 -0400
Received: by mail-pl1-f194.google.com with SMTP id g2so227679plo.3
        for <linux-bcache@vger.kernel.org>; Tue, 24 Mar 2020 19:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CS/beafctG+C5hR3ch6Lqy4XowsOGkKfFF2Q+rVKwIU=;
        b=z+RXmN+rxSeajuU//jhrlLEvjpOtUglSociFnWFPOxwZb8AA4oJkkSbbC6SIJ8f7qX
         kSppEjXsxYx90ydHugEEozCgObaO+RlJpzgnlISTOdRjC0M10Efw7mS6gKQgLLHyDUIN
         CPRtgEXUCAfOo38AiXssi8i8eWUlFyXLXbt0AI/+FNJSvXCg4kLc7KpluSTY5spQH9V7
         NwYD/F1iG6DGh5Gk2ME8wCYmqw1oWIlWtHVVmuriltntKT9kRVpaCBDYqW4Cw+WSRQms
         u9+WfsfTCvfwsmavsAT/5Cgos8QusR8Ul+KGqiWic6/MuI+q+YkYaL7ew4BYts2b7CdQ
         B+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CS/beafctG+C5hR3ch6Lqy4XowsOGkKfFF2Q+rVKwIU=;
        b=DimdibGGjhr78EnvNsl6SjC4bYrgMBPiLBqnz7LTc3dd/ToYCO3HhgFTspwofrIIBh
         Vxm4rJa7/fxBIYbcPC1v0WDm42NeVf66l1tqXaWFuBUcKdber2FG8ot+e6DBFCCjCzNC
         Qch6PHT+z/H/SXLQmiLxhoG6bqqDU/EBBttOcne2TG354rV5dGMyPUiHTEjcqmJn6Bg+
         P+QltZE6LwOgkYg1kCUVx/083A2K6EDm6lakkgjAJ/+bhFzFTwLx4Buj970JT2HVd1yD
         iyO7v0Jjt51hqkB8fNeC3S5EHmrDR9Shb37KKecOLGo+NzWHl3pa0Cl4ssPLLWXaapkT
         E6rw==
X-Gm-Message-State: ANhLgQ1ecbTIHckmDLPsiHfZvDrg590zG4SVyI3VCsd5fvU8OF3MCmtI
        M/CpnapJLFKgI8+PxuBsLQZHXQ==
X-Google-Smtp-Source: ADFU+vsQ/7y3CNr2IMZW/MIxMb6i127mirIU1vQB5xx9n5L31mCiy9GMW1gtQ1cOxjBP0Du9z6xbow==
X-Received: by 2002:a17:90a:dc83:: with SMTP id j3mr1099475pjv.64.1585104179693;
        Tue, 24 Mar 2020 19:42:59 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id a24sm16827409pfl.115.2020.03.24.19.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 19:42:59 -0700 (PDT)
Subject: Re: [PATCH 1/1] bcache: remove dupplicated declaration from btree.h
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        kbuild test robot <lkp@intel.com>
References: <20200325013057.114340-1-colyli@suse.de>
 <20200325013057.114340-2-colyli@suse.de>
 <6577c33f-5e57-f34a-8bbc-a4c17e124e11@kernel.dk>
 <364bfce6-7bbc-6bfa-fcc1-3dbb97c1acec@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <f165ad0c-c78c-d738-269b-8a6433b0bbac@kernel.dk>
Date:   Tue, 24 Mar 2020 20:42:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <364bfce6-7bbc-6bfa-fcc1-3dbb97c1acec@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/24/20 8:32 PM, Coly Li wrote:
> On 2020/3/25 9:57 上午, Jens Axboe wrote:
>> On 3/24/20 7:30 PM, Coly Li wrote:
>>> Commit ab544165dc2d ("bcache: move macro btree() and btree_root()
>>> into btree.h") makes two duplicated declaration into btree.h,
>>> 	typedef int (btree_map_keys_fn)();
>>> 	int bch_btree_map_keys();
>>>
>>> The kbuild test robot <lkp@intel.com> detects and reports this
>>> problem and this patch fixes it by removing the duplicated ones.
>>>
>>> Fixes: ab544165dc2d ("bcache: move macro btree() and btree_root() into btree.h")
>>
>> Applied, but I fixed up the commit sha, not sure where yours is from?
>>
> 
> I should use the sha from your tree, not mine. I just realize with your
> SOB the sha number should change. Sorry for the inconvenience, and I
> will notice such condition next time.
> 
> BTW, you still find such issue by your own eyes, without any extra tool?

Manual inspection, to try and avoid cases where the sha is either too
short, or just plain wrong.

-- 
Jens Axboe

