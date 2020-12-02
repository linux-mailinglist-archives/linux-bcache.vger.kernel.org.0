Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5982CCA74
	for <lists+linux-bcache@lfdr.de>; Thu,  3 Dec 2020 00:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgLBXXR (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 2 Dec 2020 18:23:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgLBXXQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 2 Dec 2020 18:23:16 -0500
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8134BC0613D6;
        Wed,  2 Dec 2020 15:22:36 -0800 (PST)
Received: by mail-qk1-x742.google.com with SMTP id i199so480949qke.5;
        Wed, 02 Dec 2020 15:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b+r2FYviV6fq0hR9F0gW+ANicng0tQNzePfUHujQp90=;
        b=P4MsC5oSelvswwlD88opOomNLvCflYz+xry1oFqYxeJx/Mp7cr2KEy3NHd5VvEgC+n
         7o5o0HRpZDL1sKFDszG2ulzSShaXZQfjNqTbUtncCnXQu4tVofeui1X2ubgWDVTeIl8M
         4l+fnDRne2vFi/RHBtqgTus9RKoQQiWg4RBuOI3PhDg4HZaxesm1/jwzSD85EztYodir
         43nwOpD4qCcc6butM1ftEH/AB9PWq6cA0cCS6kzXZmyN+CTuFfUKG32auJdwehkEX+5A
         BqatsRB3tp+NbDY7Ux2QH2geoDmveT3PP3JLj4XBEUqRI18vW4P7yrvHZeJxNvOXnLJG
         HvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=b+r2FYviV6fq0hR9F0gW+ANicng0tQNzePfUHujQp90=;
        b=L2lFm41N2u3GKSQdJl8+HCGQIRkw8hkXnB34eixi6AbbHDhTfhcxPh8DDnLZOGPrKl
         j75Cm9k3Lgf7jE/hcJ+CsFFCLYJlTxZL627UA2CZ+IIT8K0Hcd19z57OhdGOggSfLFE8
         JR9eHOUWlLM8RskIzX+/piInTsTPvycgPKkBnPfoPPIP1bcdke+lAF1MvwNBVVSxBkzD
         Fy0ZNV4qlAWyW0tWHu/6o16uLcJZ/qixT9Q6RNaqz59CizHg14GbSJQzB5EEk+C1PPW+
         nfn1mqlAAWZLEtDuaT/0U1ZWMjFt98IZCqRq2pPwcENhVCMalOW7JiAoncJ+dmbvp0B/
         U4VA==
X-Gm-Message-State: AOAM532ptLRRgJVo9yBoXXwHz3sU2BnilOTmwXCB/h8vD6hI0lhv3AYB
        H0aI4ZSmb8nbBDM4fJQKgmo=
X-Google-Smtp-Source: ABdhPJyg0LHfRF85QBVE1aNbA5meOz/wKZPBz7cbhnhS5PHEqBCsQVBc6aBImcA/HPpiZ4RRhxFhxQ==
X-Received: by 2002:a37:2c82:: with SMTP id s124mr200575qkh.130.1606951355454;
        Wed, 02 Dec 2020 15:22:35 -0800 (PST)
Received: from localhost ([2620:10d:c091:480::1:ec0f])
        by smtp.gmail.com with ESMTPSA id h125sm169910qkc.36.2020.12.02.15.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 15:22:34 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Wed, 2 Dec 2020 18:22:06 -0500
From:   Tejun Heo <tj@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 9/9] block: use an xarray for disk->part_tbl
Message-ID: <X8ghnnEfBZWG+nLr@mtj.duckdns.org>
References: <20201201165424.2030647-1-hch@lst.de>
 <20201201165424.2030647-10-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201165424.2030647-10-hch@lst.de>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Tue, Dec 01, 2020 at 05:54:24PM +0100, Christoph Hellwig wrote:
> Now that no fast path lookups in the partition table are left, there is
> no point in micro-optimizing the data structure for it.  Just use a bog
> standard xarray.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks!

-- 
tejun
