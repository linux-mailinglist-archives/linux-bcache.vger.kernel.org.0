Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6256304304
	for <lists+linux-bcache@lfdr.de>; Tue, 26 Jan 2021 16:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbhAZPwO (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 26 Jan 2021 10:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391988AbhAZPux (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 26 Jan 2021 10:50:53 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F762C061D73
        for <linux-bcache@vger.kernel.org>; Tue, 26 Jan 2021 07:50:13 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id q20so10638114pfu.8
        for <linux-bcache@vger.kernel.org>; Tue, 26 Jan 2021 07:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SsOHsp4CNkFxjdTZshpM5g+g+qO3mJ0CLTnLDYGv8F8=;
        b=Q/fVoQh5K93yJcNdbudRk4luINyrwHUURtqGAC6/JqYcOPosFilLAg+2J9JqCAyANZ
         EnsGBpNvfjgopsphz2sovbPJTKzmrCA4ASTUfBXE6n5cw0t3FfMmYTlyc1xvJ3u4wQkQ
         Y0g4X+JIUu0F+4XBCTzkbegxLAe6uGJ9kLMY+tHukHRybvSz+0BFvNicJpql+rcTOst4
         R+9elAJWLiLOLRWZkaX9ONwxX4kAU4kEKAJNJ7ldWH9kdI13qMOMw3Tw4lgEoMSa2iix
         gpvu7RWlVeK3KO+3PC7yJ38PHoTMygY6TEZX80x/gMEorKUHLXX4Y1vfo2A9Qe3S+DTK
         3pSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SsOHsp4CNkFxjdTZshpM5g+g+qO3mJ0CLTnLDYGv8F8=;
        b=rrPMardGCk+NHcuXiIAEW6OrQXsfiCqctMoNlMbI1qss8qhfF6lMIZfrOgs2Cus293
         Jf9Tilzatt1BGA3SRVOrMW5w31MGuDJwX8YD5xGmLR7oLO5LmeYT+Zmzk9w0ogt72yya
         tD8R6Rt9+/+yLCEiRYYsVEeMk0fLMtn1f/ophBiqcDcmgvqGYdcLBA2MZRxyTvNlXIEr
         iP3m0wwr4RTvjaNuSH25DGE4JErtFvmmJT+ZIAfovvINFQGrsUqE/hllA00vVruJQxRv
         VN+EzeEyHxRaJp+XUMncyu8Z6uA1GaIG/1DU3cjKKzsZ/F8B8QqQK51YHHsNApu2ETuK
         Wcrg==
X-Gm-Message-State: AOAM533jlU3H+ldGQjQ+Qd9hi7kfkF9iYYZHf6kokUdDaLP5N4OK7A7J
        PZuI31cs7Ih7nNKEo+FvBefZde3yLGoJ9g==
X-Google-Smtp-Source: ABdhPJxFgCpz0Tr3yR3J/h+CulR4O67CYepxBdICoMBSME41Ibjc9P2FhWI9Jz3iszjTH1K/mjzkMA==
X-Received: by 2002:a65:5241:: with SMTP id q1mr6163039pgp.143.1611676212261;
        Tue, 26 Jan 2021 07:50:12 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id y16sm19967027pfb.83.2021.01.26.07.50.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 07:50:11 -0800 (PST)
Subject: Re: additional ->bi_bdev fixups
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org
References: <20210126143308.1960860-1-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b33aeb19-094e-c32a-2da0-33cff6f9e418@kernel.dk>
Date:   Tue, 26 Jan 2021 08:50:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210126143308.1960860-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/26/21 7:33 AM, Christoph Hellwig wrote:
> Hi Jens,
> 
> more fixes for the (so far theoretical) fallout from the ->bi_bdev
> conversion.

Applied, thanks.

-- 
Jens Axboe

