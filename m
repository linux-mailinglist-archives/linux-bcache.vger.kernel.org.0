Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7B041A31E
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Sep 2021 00:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237999AbhI0WfS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Sep 2021 18:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237643AbhI0WfR (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Sep 2021 18:35:17 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512D7C061604
        for <linux-bcache@vger.kernel.org>; Mon, 27 Sep 2021 15:33:39 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id b15so21038570ils.10
        for <linux-bcache@vger.kernel.org>; Mon, 27 Sep 2021 15:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOsuwHDiPC+PPoCEQN/qtQeyMVFZbR3g1AzPIbWGz1s=;
        b=YTqmdXk5vu2O6Z09DphFzhzdWxPQ8jmaJFHrIsMI+6Jhr8dovpFIgf0hfWsFZmWJGq
         EVBCGkS1YFFNZ8M01WgONYjDBxGTGP/DCZWSKVCmRzFam2Hh4IgqxVmjePf268PGtV81
         f5vMDXMmwBYUfauwYcel2Rv7+Z/vgk39qzYsRkTAosBsqgB4GwDsvm6cOxLKEb7WhBzu
         TSGL2cQt0huoDrGurVnZof3FIGpxyaHR8+jLKBQHjcW0vLlSgpEdy3xv/8pfNM0RjCzL
         S68pit92xtiJTYJshqe0ROVs/67npCPOQRoa5DA5iXWksCwd+SjdXeI2A9yZ8hXhKis6
         coXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOsuwHDiPC+PPoCEQN/qtQeyMVFZbR3g1AzPIbWGz1s=;
        b=IWXMDO39h+TQBnep51IW03p9B0V9vbaqQgN3Har6D00m+Sddp+o4K9IvE+WbWxdPWB
         q583nlUgZiPtE23mTiQzAgzN/Y+uDhzfoVKfDp3v0/Le6rtqAQQE/D0xAR/SSwOU8O/y
         PgG7lV4RwpDrEx+EeOKeNntJ3qurAH5Ce4YXB9b9RxZN4O55G4mRhtBX4tt6vhPMulmz
         5XvsiDGiHhBmr4HNhn0zAPFIYAy6C7VASjzYDREoKSvH2adeTm8/EKkwBFNBBuhfsao5
         ACm4pE8RkgP5AzbANi0MyTkXEsFsjQoSo2cxa+HOxgTOPagPIgvd0+BndRjj/KSZA20u
         3Rnw==
X-Gm-Message-State: AOAM5339r127PyBUkIMlAj1XH2GXWGDq3ZVek2sjgWvDCRE/S6AjRJj2
        3CS2/rWfKsq/DDFm2y+423mOXA==
X-Google-Smtp-Source: ABdhPJwueWxtKqjP8KyNWWEV43ZHbAJgLgbtzL1ErWyEowm3/77Murhw193eceS6jFlQ9sjaEQjTVg==
X-Received: by 2002:a92:da85:: with SMTP id u5mr1851944iln.213.1632782018707;
        Mon, 27 Sep 2021 15:33:38 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y2sm6427866iot.45.2021.09.27.15.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 15:33:38 -0700 (PDT)
Subject: Re: [PATCH v2 00/10] block: second batch of add_disk() error handling
 conversions
To:     Luis Chamberlain <mcgrof@kernel.org>, colyli@suse.de,
        kent.overstreet@gmail.com, kbusch@kernel.org, sagi@grimberg.me,
        vishal.l.verma@intel.com, dan.j.williams@intel.com,
        dave.jiang@intel.com, ira.weiny@intel.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, minchan@kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org
Cc:     xen-devel@lists.xenproject.org, nvdimm@lists.linux.dev,
        linux-nvme@lists.infradead.org, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210927220039.1064193-1-mcgrof@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <c17004ed-884f-5a97-c333-602e3f9903e7@kernel.dk>
Date:   Mon, 27 Sep 2021 16:33:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210927220039.1064193-1-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 9/27/21 4:00 PM, Luis Chamberlain wrote:
> This is the second series of driver conversions for add_disk()
> error handling. You can find this set and the rest of the 7th set of
> driver conversions on my 20210927-for-axboe-add-disk-error-handling
> branch [0].

Applied 1, thanks.

-- 
Jens Axboe

