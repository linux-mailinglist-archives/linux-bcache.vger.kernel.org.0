Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 628F1E6B4C
	for <lists+linux-bcache@lfdr.de>; Mon, 28 Oct 2019 04:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbfJ1DOK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 27 Oct 2019 23:14:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:52092 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727851AbfJ1DOK (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 27 Oct 2019 23:14:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3BF42AB9B;
        Mon, 28 Oct 2019 03:14:09 +0000 (UTC)
Subject: Re: Very slow bcache-register: 6.4TB takes 10+ minutes
To:     Teodor Milkov <tm@del.bg>
References: <5008cd68-9ec5-5daf-3d56-25ea8b8a7736@del.bg>
 <224a181d-06a6-2517-865d-c71595487187@suse.de>
 <6de6d941-6ddf-317a-5b1c-b8210c6581b5@del.bg>
From:   Coly Li <colyli@suse.de>
Openpgp: preference=signencrypt
Organization: SUSE Labs
Cc:     linux-bcache@vger.kernel.org
Message-ID: <5991bb06-6ab5-c38d-4a03-64178db30988@suse.de>
Date:   Mon, 28 Oct 2019 11:14:03 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <6de6d941-6ddf-317a-5b1c-b8210c6581b5@del.bg>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2019/10/27 5:15 下午, Teodor Milkov wrote:
> Just for the record -- here are the times to register a cache device vs.
> how full it is (used % from priority_stats):
> 
> ||  GB ||     Time || GB/s ||
> |  111 |   0m10.8s |  10.3  |
> |  209 |   0m20.3s |  10.3  |
> |  433 |   0m43.1s |  10.0  |
> |  931 |   1m41.6s |   9.2  |
> | 1695 |   3m11s   |   8.9  |
> 
> This is on Intel DC P3500 series 2TB NVMe drive +
> Xeon Silver 4114 CPU @ 2.20GHz.
> 

Thanks for the information. If you may check the size of the B+tree
(/sys/fs/bcache/<cache-set-uuid>/internal/btree_nodes), maybe it can be
more clear to find a connection between B+btree size and register time.

If anybody helps to compose a patch doing multiple-kthread btree nodes
checksum check, it will be cool. It is on my to-do list, but no my
current task.

-- 

Coly Li
